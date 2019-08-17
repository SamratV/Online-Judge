#!/bin/bash
# This script creates the judging environment.

# Method for checking exit code of a command.
check(){
	if [[ $1 -ne 0 ]]; then
		echo $2
		exit 0
	fi
}

# Method for deleting a directory.
delDir(){
	if [ -d "$1" ]; then
		rm -rf $1
		check $? "Error deleting dir."
	fi
}

# Receive parameters via commandline.
USERNAME="$1"
CODE="$2"  # The runtime folder that will be mounted onto /code folder of the jail.
WORKSPACE="$CODE""$USERNAME""/"
TC_COUNT=$3 # Total number of testcases.
JAIL="$4"
LANG="$5"

# Create workspace.
delDir $WORKSPACE
mkdir $WORKSPACE
check $? "Error creating dir: workspace"

# Copy judger.
JUDGER=$WORKSPACE"judger.so"
cp /liboj/judge/judger.so $JUDGER
check $? "Error copying judger."

# Create the directories required.
STDIN=$WORKSPACE"in/"
STDOUT=$WORKSPACE"out/"
DBOUT=$WORKSPACE"db_out/"

mkdir $STDIN
check $? "Error creating dir: in"

mkdir $STDOUT
check $? "Error creating dir: out"

mkdir $DBOUT
check $? "Error creating dir: db_out"

# Create the file in the directories.
if [ "$LANG" == "c" ]; then
	touch "$WORKSPACE""Solution.c"
elif [ "$LANG" == "cpp" ]; then
    touch "$WORKSPACE""Solution.cpp"
elif [ "$LANG" == "java" ]; then
	touch "$WORKSPACE""Solution.java"
elif [ "$LANG" == "python" ]; then
	touch "$WORKSPACE""Solution.py"
else
	echo "Not a recognized language."
	exit 0
fi

ERR_FILE=$WORKSPACE"err.txt"
touch $ERR_FILE
check $? "Error creating file."

for (( i=1; i<=$TC_COUNT; i++ ))
do
	STDIN_FILE="$STDIN""$i"".txt"
	STDOUT_FILE="$STDOUT""$i"".txt"
	DBOUT_FILE="$DBOUT""$i"".txt"

	touch $STDIN_FILE
	check $? "Error creating file."

	touch $STDOUT_FILE
	check $? "Error creating file."

	touch $DBOUT_FILE
	check $? "Error creating file."
done

# Create workspace inside jail.
DIRECTORY=$JAIL"code"
if [ ! -d "$DIRECTORY" ]; then
	mkdir $DIRECTORY
	check $? "Error creating workspace."
fi

# Mount actual workspace onto jail workspace.
if mount | grep "$DIRECTORY" > /dev/null; then
    echo "/code is already mounted."
else
    mount -o bind $CODE $DIRECTORY
    check $? "Error mounting /code"
fi

# Mount proc.
PROC=$JAIL"proc"
if mount | grep "$PROC" > /dev/null; then
    echo "/proc is already mounted."
else
    mount -o bind /proc $PROC
    check $? "Error mounting /proc"
fi

# Reset permissions.
chmod -R 777 $WORKSPACE
check $? "Error chmod."

echo "Success."
exit 0