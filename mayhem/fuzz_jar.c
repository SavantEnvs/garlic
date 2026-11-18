// JAR/ZIP reader + class decompiler (garlic's `garlic x.jar [-o out] [-t n]`).
#include "harness_common.h"
#include "harness_output_state.h"
#include "jar/jar.h"

int LLVMFuzzerInitialize(int *argc, char ***argv)
{
    (void)argc; (void)argv;
    harness_silence_stdout();
    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    char dir[512], path[600], out[640];
    if (harness_stage(dir, sizeof dir, path, sizeof path, "fuzz.jar", data, size) != 0)
        return -1;
    snprintf(out, sizeof out, "%s/out", dir);
    mkdir(out, 0700);

    jar_file_analyse(path, out, 1);
    harness_reset_output_paths();
    harness_rm_rf(dir);
    return 0;
}
