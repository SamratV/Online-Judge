#ifndef SECCOMP_RULES_H
#define SECCOMP_RULES_H

#include "../child.h"

int c_cpp_seccomp_rules(char *exe_path);
int general_seccomp_rules(char *exe_path);

#endif