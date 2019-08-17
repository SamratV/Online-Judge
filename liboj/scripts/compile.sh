#!/bin/bash
# This script compiles user's code.

# Receive parameters via commandline and prepare additional parameters.
DIR="$1"
LANG="$2"
JAIL="$3"

JUDGER=$DIR"judger.so"
STDOUT=$DIR"err.txt"
ACTION="compile"
STDIN="none"

if [ "$LANG" == "c" ]; then
	CODEFILE=$DIR"Solution.c"
	COMPILED_CODE=$DIR"Solution"
	CODEFILE_PATH="none"
elif [ "$LANG" == "cpp" ]; then
    CODEFILE=$DIR"Solution.cpp"
	COMPILED_CODE=$DIR"Solution"
	CODEFILE_PATH="none"
elif [ "$LANG" == "java" ]; then
	CODEFILE=$DIR"Solution.java"
	COMPILED_CODE="none"
	CODEFILE_PATH="$DIR"
elif [ "$LANG" == "python" ]; then
	CODEFILE=$DIR"Solution.py"
	COMPILED_CODE="none"
	CODEFILE_PATH="none"
else
	echo "Not a recognized language.:0:0:-101"
	exit 0
fi

# Prepare parameters for runner.sh.
CMD="$JUDGER $LANG $ACTION $STDOUT $CODEFILE $COMPILED_CODE $CODEFILE_PATH $STDIN $JAIL"

# Finally, compile.
/liboj/scripts/runner.sh $CMD

exit 0