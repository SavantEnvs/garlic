#!/usr/bin/env bash
#
# mayhem/test.sh — RUN this repo's OWN functional test suite (already built by mayhem/build.sh).
# exit 0 = pass. EDIT per repo. PATCH-grade oracle: after an agent patches the source, the grader
# rebuilds (build.sh) then runs this. DELETE this file if the repo has no meaningful tests.
#
# IMPORTANT:
#  * Must assert BEHAVIOR/OUTPUT, not just exit status. The oracle has to check asserted values /
#    golden-output diffs / known-answer results — so a PATCH that "fixes" a bug by making the program
#    exit(0) (or any no-op) FAILS here. Running inputs and checking only "exit 0 / didn't crash" is
#    NOT a functional test (it's trivially reward-hackable) — use the project's real assertion suite.
#  * Do NOT build here — mayhem/build.sh already compiled the test suite (with the project's normal
#    flags). This script only RUNS the pre-built tests and reports counts. If the test runner is
#    missing, that's a build.sh bug — fail loudly rather than silently rebuilding.
#  * REQUIRED OUTPUT — a CTRF (https://ctrf.io) summary so Mayhem/the PATCH grader reads the counts:
#      - writes a CTRF JSON report to ${CTRF_REPORT:-$SRC/ctrf-report.json}, and
#      - prints a one-line `CTRF {...}` marker to stdout (same JSON, compact).
#    Only `results.summary` (with tests/passed/failed/pending/skipped/other) is required.
#    Use the emit_ctrf helper below; it computes tests = passed+failed+skipped and sets the exit
#    code (0 iff failed==0). Map your framework's output to passed/failed/skipped.
set -uo pipefail
[ -n "${SOURCE_DATE_EPOCH:-}" ] || unset SOURCE_DATE_EPOCH
: "${MAYHEM_JOBS:=$(nproc)}"   # build parallelism; env-overridable, falls back to nproc (use -j"$MAYHEM_JOBS")
cd "$SRC"

# emit_ctrf <tool> <passed> <failed> [skipped] [pending] [other]
# Writes a CTRF report (file + stdout `CTRF {...}` marker) and returns non-zero iff failed>0.
emit_ctrf() {
  local tool="$1" passed="$2" failed="$3" skipped="${4:-0}" pending="${5:-0}" other="${6:-0}"
  local tests=$(( passed + failed + skipped + pending + other ))
  cat > "${CTRF_REPORT:-$SRC/ctrf-report.json}" <<JSON
{
  "results": {
    "tool": { "name": "$tool" },
    "summary": {
      "tests": $tests,
      "passed": $passed,
      "failed": $failed,
      "pending": $pending,
      "skipped": $skipped,
      "other": $other
    }
  }
}
JSON
  printf 'CTRF {"results":{"tool":{"name":"%s"},"summary":{"tests":%d,"passed":%d,"failed":%d,"pending":%d,"skipped":%d,"other":%d}}}\n' \
    "$tool" "$tests" "$passed" "$failed" "$pending" "$skipped" "$other"
  [ "$failed" -eq 0 ]
}

# Known-answer oracle: run the CMake-built garlic CLI (normal flags, dynamically linked; built by
# mayhem/build.sh into build/tests) over committed fixtures and diff its output against golden files
# captured from the same build. The comparisons happen in bash/diff, so a neutered garlic cannot pass.
GARLIC="$SRC/build/tests/garlic"
FIX="$SRC/mayhem/test/fixtures"
GOLD="$SRC/mayhem/test/golden"
if [ ! -x "$GARLIC" ]; then
  echo "FATAL: $GARLIC missing (mayhem/build.sh builds it)" >&2
  emit_ctrf "garlic-kat" 0 1 0
  exit 1
fi

WORK="$(mktemp -d "${TMPDIR:-/tmp}/garlic-test.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
passed=0; failed=0

check() {   # check <name> <expected-path> <actual-path>
  if [ -e "$3" ] && diff -r -q "$2" "$3" >/dev/null 2>&1; then
    passed=$((passed + 1)); echo "ok   $1"
  else
    failed=$((failed + 1)); echo "FAIL $1"; diff -r "$2" "$3" 2>&1 | head -20
  fi
}

"$GARLIC" "$FIX/Calc.class"        > "$WORK/class.decompiled.txt" 2>/dev/null
"$GARLIC" "$FIX/Calc.class" -p     > "$WORK/class.dump.txt"       2>/dev/null
"$GARLIC" "$FIX/demo.jar" -t 1 -o "$WORK/jar"     >/dev/null 2>&1
"$GARLIC" "$FIX/demo.dex" -t 1 -o "$WORK/dex"     >/dev/null 2>&1
"$GARLIC" "$FIX/demo.dex" -p       > "$WORK/dex.dump.txt"         2>/dev/null
"$GARLIC" "$FIX/demo.dex" -s -t 1 -o "$WORK/smali" >/dev/null 2>&1
"$GARLIC" "$FIX/demo.apk" -t 1 -o "$WORK/apk"     >/dev/null 2>&1

check "class: decompiled source"          "$GOLD/class.decompiled.txt" "$WORK/class.decompiled.txt"
check "class: javap-style dump (-p)"      "$GOLD/class.dump.txt"       "$WORK/class.dump.txt"
check "jar: decompiled tree"              "$GOLD/jar"                  "$WORK/jar"
check "dex: decompiled tree"              "$GOLD/dex"                  "$WORK/dex"
check "dex: dexdump-style dump (-p)"      "$GOLD/dex.dump.txt"         "$WORK/dex.dump.txt"
check "dex: smali tree (-s)"              "$GOLD/smali"                "$WORK/smali"
check "apk: manifest + decompiled tree"   "$GOLD/apk"                  "$WORK/apk"

# Spot assertions on exact values, independent of the golden files.
grep -qF 'public int fib(int i0) {' "$WORK/class.decompiled.txt" \
  && { passed=$((passed + 1)); echo "ok   class: fib method recovered"; } \
  || { failed=$((failed + 1)); echo "FAIL class: fib method recovered"; }
grep -qF 'android:name="android.permission.INTERNET"' "$WORK/apk/AndroidManifest.xml" 2>/dev/null \
  && { passed=$((passed + 1)); echo "ok   apk: manifest permission decoded"; } \
  || { failed=$((failed + 1)); echo "FAIL apk: manifest permission decoded"; }

emit_ctrf "garlic-kat" "$passed" "$failed" 0
