// Java .class parser + decompiler (garlic's `garlic Foo.class` and `-p` paths).
#include "harness_common.h"
#include "parser/class/metadata.h"
#include "jvm/jvm_decompile.h"
#include "libs/memory/mem_pool.h"

int LLVMFuzzerInitialize(int *argc, char ***argv)
{
    (void)argc; (void)argv;
    harness_silence_stdout();
    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    // A ClassFile starts with u4 magic, u2 minor, u2 major, u2 constant_pool_count (JVMS 4.1), 10 bytes.
    // parse_constant_pool_section abort()s ("const poll error") on any input too short to hold a tag, so
    // without this floor the first inputs libFuzzer tries (the empty one, then 1-byte mutations) all abort
    // and the fuzzer never gets going. The abort stays reachable from every longer truncated or bad-tag file.
    if (size < 10)
        return -1;
    char dir[512], path[600];
    if (harness_stage(dir, sizeof dir, path, sizeof path, "Fuzz.class", data, size) != 0)
        return -1;

    mem_init_pool();
    jclass_file *jc = parse_class_file(path);
    int rc = -1;
    if (jc != NULL) {
        print_java_class_file_info(jc);
        jvm_analyse_class_file(jc->jfile);
        rc = 0;
    }
    mem_free_pool();
    harness_rm_rf(dir);
    return rc;
}
