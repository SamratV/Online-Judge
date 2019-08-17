#ifndef RUNNER_H
#define RUNNER_H

#include <sys/types.h>
#include <stdio.h>

#define UNKNOWN_ACTION -100
#define UNKNOWN_LANG -101
#define ROOT_REQUIRED -102
#define FORK_FAILED -103
#define PTHREAD_FAILED -104
#define CHILD_WAIT_FAILED -105

#define MEMORY_LIMIT_EXCEEDED -301
#define TIME_LIMIT_EXCEEDED -302
#define REAL_TIME_LIMIT_EXCEEDED -303
#define COMPILE_TIME_ERROR -304
#define RUNTIME_ERROR -305
#define FLOATING_POINT_EXCEPTION -306
#define SEGMENTATION_FAULT -307
#define BAD_MEMORY_ACCESS -308
#define SYSTEM_CALL -309
#define OUTPUT_SIZE_EXCEEDED -310

struct config{
    char *lang;
    char *action;
    char **args;
    char **env;
    char *path;
    char *stdin;
    char *stdout;
    int timeout;
    long mem_limit;
    long stack_limit;
    long out_size;
    int nproc;
    uid_t uid;
    gid_t gid;
};

struct result{
    int exit_code;
    char *message;
    long mem_used;
    int time_used;
};

void run(struct config *, struct result *);

#endif