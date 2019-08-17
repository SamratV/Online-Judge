#define _GNU_SOURCE
#define _POSIX_SOURCE

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sched.h>
#include <signal.h>
#include <pthread.h>
#include <wait.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>

#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>

#include "runner.h"
#include "child.h"
#include "util.h"

char* getMessage(int value){// Only for child related errors.
    switch(value){
        case LOAD_SECCOMP_FAILED:       return "Load seccomp failed.";
                                        break;
        case SETRLIMIT_STACK_FAILED:    return "Setrlimit stack failed.";
                                        break;
        case SETRLIMIT_MEMCHK_FAILED:   return "Setrlimit memchk failed.";
                                        break;
        case SETRLIMIT_TIME_FAILED:     return "Setrlimit time failed.";
                                        break;
        case SETRLIMIT_NPROC_FAILED:    return "Setrlimit nproc failed.";
                                        break;
        case SETRLIMIT_OUTSIZE_FAILED:  return "Setrlimit outsize failed.";
                                        break;
        case DUP2_FAILED:               return "Dup2 failed.";
                                        break;
        case SETGID_FAILED:             return "Setgid failed.";
                                        break;
        case SETUID_FAILED:             return "Setuid failed.";
                                        break;
        case EXECVE_FAILED:             return "Execve failed.";
                                        break;
        case LOG_WRITE_FAILED:          return "System error logger failed.";
                                        break;
        default:                        return "Unknown exit code.";
    }
}

int get_memory_usage(pid_t pid){
    int fd, data, stack;
    char buf[4096], status_child[NAME_MAX];
    char *vm;

    sprintf(status_child, "/proc/%d/status", pid);
    if((fd = open(status_child, O_RDONLY)) < 0)     return -1;

    read(fd, buf, 4095);
    buf[4095] = '\0';
    close(fd);

    data = stack = 0;

    vm = strstr(buf, "VmData:");
    if(vm){
        sscanf(vm, "%*s %d", &data);
    }
    vm = strstr(buf, "VmStk:");
    if(vm){
        sscanf(vm, "%*s %d", &stack);
    }

    return data + stack;    
}

int max(int a, int b){
    return a > b ? a : b;
}

void run(struct config *_config, struct result *_result){
    // check whether current user is root
    uid_t uid = getuid();
    if (uid != 0) {
        char *s = "Root required.";
        _result->message = s;
        _result->exit_code = ROOT_REQUIRED;
        return;
    }

    // record current time
    struct timeval start, end;
    gettimeofday(&start, NULL);

    pid_t child_pid = fork();

    // pid < 0 shows clone failed
    if (child_pid < 0) {
        char *s = "Fork failed.";
        _result->message = s;
        _result->exit_code = FORK_FAILED;
        return;
    }
    else if (child_pid == 0) {
        child_process(_config);
    }
    else if (child_pid > 0){
        // create new thread to monitor process running time
        pthread_t tid = 0;
        
        struct timeout_killer_args killer_args;

        killer_args.timeout = _config->timeout * 1000 + 8000;
        killer_args.pid = child_pid;
        if (pthread_create(&tid, NULL, timeout_killer, (void *) (&killer_args)) != 0) {
            kill_pid(child_pid);
            char *s = "Pthread failed.";
            _result->message = s;
            _result->exit_code = PTHREAD_FAILED;
            return;
        }
        

        int status;
        struct rusage resource_usage;

        int memory_used = 128;
        pid_t pid2;

        do{
            memory_used = max(memory_used, get_memory_usage(child_pid));
            if (((long) memory_used) * 1024 > _config->mem_limit * 2)   kill_pid(child_pid);

            // wait for the child process to change state
            pid2 = wait4(child_pid, &status, WUNTRACED | WCONTINUED, &resource_usage);
            // on success, returns the process ID of the child whose state has changed;
            // On error, -1 is returned.
            if(pid2 == -1){
                kill_pid(child_pid);
                char *s = "Child wait failed.";
                _result->message = s;
                _result->exit_code = CHILD_WAIT_FAILED;
                return;
            }
        }while(pid2 == 0);

        // get end time
        gettimeofday(&end, NULL);
        int real_time = (int) (end.tv_sec * 1000 + end.tv_usec / 1000 - start.tv_sec * 1000 - start.tv_usec / 1000);
        
        // process exited, we may need to cancel timeout killer thread
        if(pthread_cancel(tid) != 0){
            // todo logging
        }

        int signal = 0;
        if(WIFSIGNALED(status) != 0) {
            signal = WTERMSIG(status);
        }

        if(signal == SIGUSR1){
            _result->exit_code = read_log(_config->stdout);
            _result->message   = getMessage(_result->exit_code);
        }else if(signal == SIGUSR2){
            _result->exit_code = LOG_WRITE_FAILED;
            _result->message   = getMessage(_result->exit_code);
        }else{
            _result->exit_code = WEXITSTATUS(status);

            int cpu_time = (int)(resource_usage.ru_utime.tv_sec * 1000 + resource_usage.ru_utime.tv_usec / 1000);
            long memory  = resource_usage.ru_maxrss * 1024;

            _result->mem_used = memory;
            _result->time_used = cpu_time;

            if(memory > _config->mem_limit){
                char *s = "Memory limit exceeded.";
                _result->exit_code = MEMORY_LIMIT_EXCEEDED;
                _result->message = s;
            }else if(real_time > _config->timeout * 1000 + 8000){
                char *s = "Real time limit exceeded.";
                _result->exit_code = REAL_TIME_LIMIT_EXCEEDED;
                _result->message = s;
            }else if(signal == SIGXCPU || cpu_time > _config->timeout * 1000){
                char *s = "Time limit exceeded.";
                _result->exit_code = TIME_LIMIT_EXCEEDED;
                _result->message = s;
            }else if(signal == SIGFPE){
                char *s = "Floating-point exception.";
                _result->exit_code = FLOATING_POINT_EXCEPTION;
                _result->message = s;
            }else if(signal == SIGSEGV){
                char *s = "Segmentation fault.";
                _result->exit_code = SEGMENTATION_FAULT;
                _result->message = s;
            }else if(signal == SIGBUS){
                char *s = "Bus error (bad memory access).";
                _result->exit_code = BAD_MEMORY_ACCESS;
                _result->message = s;
            }else if(signal == SIGSYS){
                char *s = "Bad system call.";
                _result->exit_code = SYSTEM_CALL;
                _result->message = s;
            }else if(signal == SIGXFSZ){
                char *s = "Output file size limit exceeded.";
                _result->exit_code = OUTPUT_SIZE_EXCEEDED;
                _result->message = s;
            }else if(signal != 0 || _result->exit_code != 0){
                if(strcmp(_config->action, "run") == 0){
                    char *s = "Runtime error.";
                    _result->exit_code = RUNTIME_ERROR;
                    _result->message = s;
                }else{
                    char *s = "Compile time error.";
                    _result->exit_code = COMPILE_TIME_ERROR;
                    _result->message = s;
                }
            }else{
                char *s = "Success.";
                _result->exit_code = 0;
                _result->message = s;
            }
        }
    }
}