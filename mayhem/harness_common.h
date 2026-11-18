// Shared helpers for the garlic harnesses. garlic's entry points take paths, so each input is written to
// <scratch>/garlic-<pid>/work/ (scratch = $TMPDIR, else the cwd) and that directory is removed after the input.
#ifndef GARLIC_HARNESS_COMMON_H
#define GARLIC_HARNESS_COMMON_H

#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <ftw.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

// Entry points print progress and decompiled source to stdout; silence it so runs stay fast.
static void harness_silence_stdout(void)
{
    int fd = open("/dev/null", O_WRONLY);
    if (fd >= 0) {
        dup2(fd, STDOUT_FILENO);
        close(fd);
    }
}

static int harness_rm_cb(const char *p, const struct stat *sb, int flag, struct FTW *ftw)
{
    (void)sb; (void)flag; (void)ftw;
    return remove(p);
}

static void harness_rm_rf(const char *dir)
{
    nftw(dir, harness_rm_cb, 16, FTW_DEPTH | FTW_PHYS);
}

static char harness_scratch[400];
static char harness_root[512];
static pid_t harness_root_pid;

static void harness_root_cleanup(void)
{
    if (harness_root_pid == getpid())
        harness_rm_rf(harness_root);
}

// A crash (ASan abort, OOM, timeout kill) skips the exit handler and leaves garlic-<pid>/ behind. Each
// new process removes the roots of processes that no longer exist, so nothing accumulates.
static void harness_sweep_dead_roots(void)
{
    DIR *d = opendir(harness_scratch);
    if (d == NULL)
        return;
    struct dirent *e;
    while ((e = readdir(d)) != NULL) {
        char *end;
        if (strncmp(e->d_name, "garlic-", 7) != 0)
            continue;
        long pid = strtol(e->d_name + 7, &end, 10);
        if (end == e->d_name + 7 || *end != '\0' || pid <= 0 || (pid_t)pid == getpid())
            continue;
        if (kill((pid_t)pid, 0) == -1 && errno == ESRCH) {
            char p[sizeof harness_root + 300];
            snprintf(p, sizeof p, "%s/%s", harness_scratch, e->d_name);
            harness_rm_rf(p);
        }
    }
    closedir(d);
}

static int harness_make_root(void)
{
    if (harness_root_pid == getpid())
        return 0;
    const char *t = getenv("TMPDIR");
    snprintf(harness_scratch, sizeof harness_scratch, "%s", (t != NULL && *t != '\0') ? t : ".");
    harness_sweep_dead_roots();
    snprintf(harness_root, sizeof harness_root, "%s/garlic-%ld", harness_scratch, (long)getpid());
    harness_rm_rf(harness_root);
    if (mkdir(harness_root, 0700) != 0)
        return -1;
    harness_root_pid = getpid();
    atexit(harness_root_cleanup);
    return 0;
}

// Creates a fresh <root>/work holding the input as <work>/<name>. Returns 0 on success.
static int harness_stage(char *dir, size_t dirlen, char *path, size_t pathlen,
                         const char *name, const uint8_t *data, size_t size)
{
    if (harness_make_root() != 0)
        return -1;
    snprintf(dir, dirlen, "%s/work", harness_root);
    harness_rm_rf(dir);
    if (mkdir(dir, 0700) != 0)
        return -1;
    snprintf(path, pathlen, "%s/%s", dir, name);
    FILE *f = fopen(path, "wb");
    if (f == NULL) {
        harness_rm_rf(dir);
        return -1;
    }
    if (size > 0 && fwrite(data, 1, size, f) != size) {
        fclose(f);
        harness_rm_rf(dir);
        return -1;
    }
    fclose(f);
    return 0;
}

#endif
