#!/bin/bash
# This script runs user's code and matches the output.

# Receive parameters via commandline and prepare additional parameters.
DIR="$1"
LANG="$2"
TCNO="$3" # Testcase number that is being run.
JAIL="$4"
WORKSPACE="$5" # workspace/username/

JUDGER=$DIR"judger.so"
STDIN="$DIR""in/""$TCNO"".txt"
STDOUT="$DIR""out/""$TCNO"".txt"
USROUT="$WORKSPACE""out/""$TCNO"".txt"
DBOUT="$WORKSPACE""db_out/""$TCNO"".txt"
ACTION="run"

if [ "$LANG" == "c" ] || [ "$LANG" == "cpp" ]; then
    CODEFILE="none"
	COMPILED_CODE=$DIR"Solution"
	CODEFILE_PATH=$DIR"Solution"
elif [ "$LANG" == "java" ]; then
	CODEFILE="none"
	COMPILED_CODE="Solution"
	CODEFILE_PATH=$DIR
elif [ "$LANG" == "python" ]; then
	CODEFILE="none"
	COMPILED_CODE=$DIR"__pycache__/Solution.cpython-36.pyc"
	CODEFILE_PATH="none"
else
	echo "Not a recognized language.:0:0:-101"
	exit 0
fi

# Prepare parameters for runner.sh.
CMD="$JUDGER $LANG $ACTION $STDOUT $CODEFILE $COMPILED_CODE $CODEFILE_PATH $STDIN $JAIL"

# Run the code.
OUTPUT="$(/liboj/scripts/runner.sh $CMD)"

# Match output.
if [[ $OUTPUT == "Success."* ]]; then
    diff -aZ $DBOUT $USROUT > /dev/null
    echo "$OUTPUT"":""$?"
else
    echo $OUTPUT":1"
fi

exit 0