// garlic's output_path.c keeps process-global maps keyed by output path that are never freed, so every
// input would add entries. Compiling it into the harness (the archive member is then not linked) lets the
// harness reset them after each input, which makes an input's result independent of earlier ones.
#ifndef GARLIC_HARNESS_OUTPUT_STATE_H
#define GARLIC_HARNESS_OUTPUT_STATE_H

#include "common/output_path.c"

static void harness_reset_output_paths(void)
{
    mem_pool_free(paths);
    paths = NULL;
    claimed = NULL;
    resolved = NULL;
    path_once = (pthread_once_t) PTHREAD_ONCE_INIT;
}

#endif
