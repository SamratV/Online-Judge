#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "runner.h"

int main(int argc, char **argv){
    char *lang = argv[1];// c, c++, java or python
    char *action = argv[2];// compile or run
    char *stdout = argv[3];// output and error path
    char *codefile = argv[4];// codefile path with name
    char *compiled_code = argv[5];// classname or executable path with name
    char *codefile_path = argv[6];// codefile path for -cp and -d in java
    char *input = argv[7];// input path

    char **args;
    char **env;
    char *path;

    int timeout      = 30;
    int nproc        = 1000;
    long mem_limit   = 128 * 1024 * 1024;
    long stack_limit = 32 * 1024 * 1024;
    long out_size    = 16 * 1024 * 1024;

    if(strcmp(action, "compile") == 0){
        if(strcmp(lang, "c") == 0){
            char *cmd[] = {"/usr/bin/gcc",
                        "-std=gnu11",
                        "-w",
                        "-O2",
                        "-fomit-frame-pointer",
                        "5",// 5th index -> codefile
                        "-o",
                        "7",// 7th index -> compiled_code
                        "-lm",
                        NULL};
            cmd[5] = codefile;
            cmd[7] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/gcc";
        }else if(strcmp(lang, "cpp") == 0){
            char *cmd[] = {"/usr/bin/g++",
                        "-std=gnu++14",
                        "-w",
                        "-O2",
                        "-fomit-frame-pointer",
                        "5",// 5th index -> codefile
                        "-o",
                        "7",// 7th index -> compiled_code
                        "-lm",
                        NULL};
            cmd[5] = codefile;
            cmd[7] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/g++";
        }else if(strcmp(lang, "java") == 0){
            char *cmd[] = {"/usr/bin/javac",
                        "1",// 1st index -> codefile
                        "-d",
                        "3",// 3rd index -> codefile_path
                        NULL};
            cmd[1] = codefile;
            cmd[3] = codefile_path;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/javac";
        }else if(strcmp(lang, "python") == 0){
            char *cmd[] = {"/usr/bin/python3",
                        "-m",
                        "py_compile",
                        "3",// 3rd index -> codefile
                        NULL};
            cmd[3] = codefile;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8",
                        "MALLOC_ARENA_MAX=1", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/python3";
        }else{
            printf("Not a recognized language.\n");
            return UNKNOWN_LANG;
        }
    }else if(strcmp(action, "run") == 0){
        if(strcmp(lang, "c") == 0){
            char *cmd[] = {"0", NULL};
            cmd[0] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = codefile_path;
            timeout = 2;
        }else if(strcmp(lang, "cpp") == 0){
            char *cmd[] = {"0", NULL};
            cmd[0] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = codefile_path;
            timeout = 2;
        }else if(strcmp(lang, "java") == 0){
            char *cmd[] = {"/usr/bin/java",
                        "-cp",
                        "2",// 2nd index -> codefile_path
                        "-Xss1M",
                        "-Xms16M",
                        "-Xmx128M",
                        "-Djava.security.manager",
                        "-Djava.security.policy==/etc/java_policy",
                        "-Djava.awt.headless=true",
                        "9",// 9th index -> compiled_code
                        NULL};
            cmd[2] = codefile_path;
            cmd[9] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/java";
            timeout = 4;
        }else if(strcmp(lang, "python") == 0){
            char *cmd[] = {"/usr/bin/python3",
                        "1",// 1st index -> compiled_code
                        NULL};
            cmd[1] = compiled_code;
            char *envir[] = {"PATH=/usr/local/bin:/usr/bin:/bin",
                        "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8",
                        "MALLOC_ARENA_MAX=1", NULL};
            args = cmd;
            env = envir;
            path = "/usr/bin/python3";
            timeout = 5;
        }else{
            printf("Not a recognized language.\n");
            return UNKNOWN_LANG;
        }
    }else{
        printf("Not a recognized action.\n");
        return UNKNOWN_ACTION;
    }

    struct config _config;
    _config.lang        = lang;
    _config.action      = action;
    _config.args        = args;
    _config.env         = env;
    _config.path        = path;
    _config.stdin       = input;
    _config.stdout      = stdout;
    _config.timeout     = timeout;
    _config.mem_limit   = mem_limit;
    _config.stack_limit = stack_limit;
    _config.out_size    = out_size;
    _config.nproc       = nproc;
    _config.uid         = 65534;
    _config.gid         = 65534;

    struct result _result;
    _result.exit_code   = 0;
    _result.message     = "";

    run(&_config, &_result);

    printf("%s:", _result.message); // Message
    printf("%ld:", _result.mem_used); // Memory used (in bytes)
    printf("%d:", _result.time_used); // CPU time used (in ms)
    printf("%d", _result.exit_code); // Exit code

    return _result.exit_code;
}