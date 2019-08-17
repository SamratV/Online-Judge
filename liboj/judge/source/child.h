#ifndef CHILD_H
#define CHILD_H

#include "runner.h"

#define LOAD_SECCOMP_FAILED -200
#define SETRLIMIT_STACK_FAILED -201
#define SETRLIMIT_MEMCHK_FAILED -202
#define SETRLIMIT_TIME_FAILED -203
#define SETRLIMIT_NPROC_FAILED -204
#define SETRLIMIT_OUTSIZE_FAILED -205
#define DUP2_FAILED -206
#define SETGID_FAILED -207
#define SETUID_FAILED -208
#define EXECVE_FAILED -209
#define LOG_WRITE_FAILED -210

void child_process(struct config *_config);

#endif