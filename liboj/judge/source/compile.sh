gcc -o util.o -c util.c;
gcc -o child.o -c child.c;
gcc -o runner.o -c runner.c;
gcc -o rules/c_cpp.o -c rules/c_cpp.c;
gcc -o rules/general.o -c rules/general.c;
gcc -pthread main.c runner.o child.o util.o rules/c_cpp.o rules/general.o -o judger.so -lseccomp;

rm util.o;
rm child.o;
rm runner.o;
rm rules/c_cpp.o;
rm rules/general.o;