#!/usr/bin/env bash
#
# mayhem/build.sh — build garlic's fuzz harnesses (sanitized, in-process libFuzzer), their standalone
# reproducers, and the normal-flags CLI that mayhem/test.sh drives. Offline and re-runnable.
set -euo pipefail

[ -n "${SOURCE_DATE_EPOCH:-}" ] || unset SOURCE_DATE_EPOCH

: "${SANITIZER_FLAGS=-fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer}"
: "${DEBUG_FLAGS:=-g -gdwarf-3}"
: "${CC:=clang}" ; : "${CXX:=clang++}" ; : "${LIB_FUZZING_ENGINE:=-fsanitize=fuzzer}"
: "${MAYHEM_JOBS:=$(nproc)}"
: "${COVERAGE_FLAGS=}"
: "${SRC:=/mayhem}"
export SANITIZER_FLAGS DEBUG_FLAGS CC CXX LIB_FUZZING_ENGINE MAYHEM_JOBS COVERAGE_FLAGS

cd "$SRC"

# --- 1) the project itself, sanitized, as a static archive (everything in CMakeLists' JAVA_DEC) ---------
FUZZ_DIR="$SRC/build/fuzz"
mkdir -p "$FUZZ_DIR/obj" /mayhem

INCLUDES="-Isrc/common -Isrc/libs/memory -Isrc/libs/hashmap -Isrc/libs/list -Isrc/libs/bitset
 -Isrc/libs/queue -Isrc/libs/str -Isrc/libs/zip -Isrc/libs/threadpool -Isrc/libs/cjson -Isrc/libs/md4c
 -Ilibs/include -Isrc/ai -Isrc/jar -Isrc/dalvik -Isrc/decompiler -Isrc/decompiler/transformer -Isrc"

# Upstream compiles with these diagnostics off (CMakeLists.txt); keep its build contract.
WARN_FLAGS="-w -Wno-implicit-function-declaration -Wno-incompatible-pointer-types
 -Wno-incompatible-function-pointer-types -Wno-int-conversion"

# UBSan relaxation: upstream stores callbacks in void* typed hashmap/list comparators with mismatched
# prototypes (function), and the DEX/class readers sign-extend with signed shifts (shift-base); both are
# benign and would halt on every input.
UB_RELAX="-fno-sanitize=function -fno-sanitize=shift-base"

SRC_LIST="$FUZZ_DIR/sources.txt"
{
  for d in common libs/list libs/hashmap parser/class parser/dex libs/queue libs/str libs/memory libs/zip \
           libs/threadpool libs/bitset libs/cjson decompiler decompiler/transformer jar jvm apk dalvik \
           libs/trie analyzer ai; do
    ls src/$d/*.c 2>/dev/null
  done
  echo src/libs/md4c/md4c.c; echo src/libs/md4c/md4c-html.c; echo src/libs/md4c/entity.c
  echo src/report/report.c
  echo src/rosemary/rosemary_embed.c
} | sort -u > "$SRC_LIST"

compile_one() {
  local f="$1" o
  o="$FUZZ_DIR/obj/$(echo "${f%.c}" | tr / _).o"
  $CC -std=gnu99 -O1 $SANITIZER_FLAGS $UB_RELAX $DEBUG_FLAGS -fsanitize=fuzzer-no-link -pthread \
      $WARN_FLAGS $INCLUDES -c "$f" -o "$o"
}
export -f compile_one
export FUZZ_DIR INCLUDES WARN_FLAGS UB_RELAX
xargs -a "$SRC_LIST" -P "$MAYHEM_JOBS" -I{} bash -c 'compile_one {}'

rm -f "$FUZZ_DIR/libgarlic.a"
ar rcs "$FUZZ_DIR/libgarlic.a" "$FUZZ_DIR"/obj/*.o

# --- 2) harnesses: fuzzer binary + standalone reproducer each; LSan hook linked into every one --------
$CXX $SANITIZER_FLAGS $DEBUG_FLAGS -c mayhem/lsan_off.cc -o "$FUZZ_DIR/lsan_off.o"
$CC $SANITIZER_FLAGS $DEBUG_FLAGS -c "$STANDALONE_FUZZ_MAIN" -o "$FUZZ_DIR/standalone_main.o"

for h in fuzz_class fuzz_jar fuzz_dex fuzz_smali fuzz_apk fuzz_callgraph fuzz_http; do
  $CC -std=gnu99 -O1 $SANITIZER_FLAGS $UB_RELAX $DEBUG_FLAGS -fsanitize=fuzzer-no-link $WARN_FLAGS $INCLUDES \
      -Imayhem -c "mayhem/$h.c" -o "$FUZZ_DIR/$h.o"
  $CC $SANITIZER_FLAGS $DEBUG_FLAGS $LIB_FUZZING_ENGINE "$FUZZ_DIR/$h.o" "$FUZZ_DIR/lsan_off.o" \
      "$FUZZ_DIR/libgarlic.a" -lpthread -ldl -lm -o "/mayhem/$h"
  $CC $SANITIZER_FLAGS $DEBUG_FLAGS "$FUZZ_DIR/standalone_main.o" "$FUZZ_DIR/$h.o" "$FUZZ_DIR/lsan_off.o" \
      "$FUZZ_DIR/libgarlic.a" -lpthread -ldl -lm -o "/mayhem/$h-standalone"
done

# --- 3) the CLI for test.sh, upstream's own CMake build with its normal flags -------------------------
cmake -B build/tests -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$COVERAGE_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
cmake --build build/tests -j"$MAYHEM_JOBS" --target garlic
