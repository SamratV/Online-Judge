#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>

int main(int argc, char **argv){
    setuid(geteuid());
    char s[500] = "";
    snprintf(s, sizeof(s), "/liboj/scripts/compile.sh %s %s %s", argv[1], argv[2], argv[3]);
    system(s);
    return 0;
}
