// The report HTTP server's request handler (`garlic --serve`): untrusted request bytes in, files under the
// served root out. handle_client is static, so the harness compiles http_server.c in and gives it one end
// of a socketpair.
#include "harness_common.h"
#include <sys/socket.h>
#include "ai/http_server.c"

int LLVMFuzzerInitialize(int *argc, char ***argv)
{
    (void)argc; (void)argv;
    harness_silence_stdout();
    return 0;
}

static void put_file(const char *dir, const char *name, const char *text)
{
    char p[700];
    snprintf(p, sizeof p, "%s/%s", dir, name);
    FILE *f = fopen(p, "wb");
    if (f != NULL) {
        fputs(text, f);
        fclose(f);
    }
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    char root[512], unused[600], sub[640];
    if (harness_stage(root, sizeof root, unused, sizeof unused, "index.html", data, 0) != 0)
        return -1;
    snprintf(sub, sizeof sub, "%s/docs", root);
    mkdir(sub, 0700);
    put_file(root, "index.html", "<html><body>report</body></html>\n");
    put_file(root, "a.json", "{\"k\":1}\n");
    put_file(sub, "b.txt", "hello\n");

    int sv[2];
    if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv) != 0) {
        harness_rm_rf(root);
        return -1;
    }
    fcntl(sv[0], F_SETFL, fcntl(sv[0], F_GETFL) | O_NONBLOCK);
    fcntl(sv[1], F_SETFL, fcntl(sv[1], F_GETFL) | O_NONBLOCK);
    if (size > 0)
        (void)send(sv[0], data, size, MSG_NOSIGNAL);
    shutdown(sv[0], SHUT_WR);

    handle_client(sv[1], root);

    close(sv[0]);
    harness_rm_rf(root);
    return 0;
}
