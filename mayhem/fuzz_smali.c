// DEX to smali (`garlic x.dex -s`).
#include "harness_common.h"
#include "harness_output_state.h"
#include "dalvik/dex_decompile.h"
#include "libs/memory/mem_pool.h"

int LLVMFuzzerInitialize(int *argc, char ***argv)
{
    (void)argc; (void)argv;
    harness_silence_stdout();
    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    char dir[512], path[600], out[640];
    if (harness_stage(dir, sizeof dir, path, sizeof path, "fuzz.dex", data, size) != 0)
        return -1;
    snprintf(out, sizeof out, "%s/out", dir);
    mkdir(out, 0700);

    dex_file_analyse(path, out, 1, JD_DEX_TASK_SMALI);
    mem_free_pool();
    harness_reset_output_paths();
    harness_rm_rf(dir);
    return 0;
}
