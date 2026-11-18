// DEX parser + Dalvik decompiler (`garlic x.dex`) and the dexdump-style `-p` dump.
#include "harness_common.h"
#include "harness_output_state.h"
#include "dalvik/dex_decompile.h"
#include "dalvik/dex_dump.h"
#include "parser/dex/metadata.h"
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

    // Same steps as dex_file_dump(), which never frees the parser's pool.
    mem_init_pool();
    jd_meta_dex *meta = parse_dex_file(path);
    dexdump(meta);
    mem_pool_free(meta->pool);
    mem_free_pool();
    dex_file_analyse(path, out, 1, JD_DEX_TASK_DECOMPILE);
    mem_free_pool();
    harness_reset_output_paths();
    harness_rm_rf(dir);
    return 0;
}
