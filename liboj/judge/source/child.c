#define _DEFAULT_SOURCE
#define _POSIX_SOURCE
#define _GNU_SOURCE
#include <stdio.h>
#include <stdarg.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <grp.h>
#include <dlfcn.h>
#include <errno.h>
#include <sched.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mount.h>

#include "runner.h"
#include "child.h" 
#include "rules/seccomp_rules.h"
#include "util.h"

void child_process(struct config *_config) {
    FILE *input_file = NULL, *output_file = NULL, *error_file = NULL;

    // set stack limit
    struct rlimit max_stack;
    max_stack.rlim_cur = max_stack.rlim_max = (rlim_t) (_config->stack_limit);
    if(setrlimit(RLIMIT_STACK, &max_stack) != 0)    write_log(_config->stdout, SETRLIMIT_STACK_FAILED);

    // set memory limit
    // if lang != 'java', we only check memory usage number
    if(strcmp(_config->lang, "java") != 0){
        struct rlimit max_memory;
        max_memory.rlim_cur = max_memory.rlim_max = (rlim_t) (_config->mem_limit) * 2;
        if(setrlimit(RLIMIT_AS, &max_memory) != 0)   write_log(_config->stdout, SETRLIMIT_MEMCHK_FAILED);        
    }

    // set max process number limit
    struct rlimit max_process_number;
    max_process_number.rlim_cur = max_process_number.rlim_max = (rlim_t) _config->nproc;
    if(setrlimit(RLIMIT_NPROC, &max_process_number) != 0)   write_log(_config->stdout, SETRLIMIT_NPROC_FAILED);

    // set cpu time limit (in seconds)
    struct rlimit max_cpu_time;
    max_cpu_time.rlim_cur = max_cpu_time.rlim_max = (rlim_t) (_config->timeout + 1);
    if(setrlimit(RLIMIT_CPU, &max_cpu_time) != 0)   write_log(_config->stdout, SETRLIMIT_TIME_FAILED);

    // set max output size limit
    struct rlimit max_output_size;
    max_output_size.rlim_cur = max_output_size.rlim_max = (rlim_t ) _config->out_size;
    if(setrlimit(RLIMIT_FSIZE, &max_output_size) != 0)   write_log(_config->stdout, SETRLIMIT_OUTSIZE_FAILED);

    if(strcmp(_config->action, "compile") == 0){
        // redirect stderr -> file
        error_file = fopen(_config->stdout, "w");
        if(error_file == NULL)  write_log(_config->stdout, DUP2_FAILED);
        if(dup2(fileno(error_file), fileno(stderr)) == -1)  write_log(_config->stdout, DUP2_FAILED);
    }else{
        // redirect stdin -> file
        input_file = fopen(_config->stdin, "r");
        if(input_file == NULL)  write_log(_config->stdout, DUP2_FAILED);
        if(dup2(fileno(input_file), fileno(stdin)) == -1)   write_log(_config->stdout, DUP2_FAILED);

        // redirect stdout -> file
        output_file = fopen(_config->stdout, "w");
        if(output_file == NULL) write_log(_config->stdout, DUP2_FAILED);
        if(dup2(fileno(output_file), fileno(stdout)) == -1) write_log(_config->stdout, DUP2_FAILED);

        // redirect stderr -> file
        error_file = output_file;
        if(dup2(fileno(error_file), fileno(stderr)) == -1)  write_log(_config->stdout, DUP2_FAILED);
    }

    // set gid
    gid_t group_list[] = {_config->gid};
    if(_config->gid != -1 && (setgid(_config->gid) == -1 || setgroups(sizeof(group_list) / sizeof(gid_t), group_list) == -1))  write_log(_config->stdout, SETGID_FAILED);

    // set uid
    if(_config->uid != -1 && setuid(_config->uid) == -1)    write_log(_config->stdout, SETUID_FAILED);

    // load seccomp
    if(strcmp(_config->action, "run") == 0){
        if(strcmp(_config->lang, "c") == 0 || strcmp(_config->lang, "cpp") == 0){
            if(c_cpp_seccomp_rules(_config->path) != 0)     write_log(_config->stdout, LOAD_SECCOMP_FAILED);
        }else if(strcmp(_config->lang, "python") == 0){
            if(general_seccomp_rules(_config->path) != 0)   write_log(_config->stdout, LOAD_SECCOMP_FAILED);
        }
    }

    execve(_config->path, _config->args, _config->env);
    write_log(_config->stdout, EXECVE_FAILED);
}