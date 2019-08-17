#ifndef UTIL_H
#define UTIL_H

struct timeout_killer_args {
    int pid;
    int timeout;
};

int kill_pid(pid_t pid);

void *timeout_killer(void *timeout_killer_args);

void write_log(char *file, int value);

int read_log(char *file);

#endif