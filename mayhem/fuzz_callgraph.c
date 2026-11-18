// Call-graph analyzer (`garlic x.dex|x.apk -g`): its own DEX/APK reader and API matcher.
#include "harness_common.h"
#include "analyzer/jd_analyzer.h"
#include "libs/memory/mem_pool.h"

int LLVMFuzzerInitialize(int *argc, char ***argv)
{
    (void)argc; (void)argv;
    harness_silence_stdout();
    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    int is_apk = size >= 2 && data[0] == 'P' && data[1] == 'K';
    char dir[512], path[600], out[640];
    if (harness_stage(dir, sizeof dir, path, sizeof path,
                      is_apk ? "fuzz.apk" : "fuzz.dex", data, size) != 0)
        return -1;
    snprintf(out, sizeof out, "%s/out", dir);
    mkdir(out, 0700);

    mem_init_pool();
    if (is_apk)
        apk_analyzer(path, out);
    else
        jd_dex_analyzer_from_file(path, out);
    mem_free_pool();
    harness_rm_rf(dir);
    return 0;
}
