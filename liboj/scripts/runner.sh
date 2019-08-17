#!/bin/bash
# This script runs command inside chroot.

# Receive parameters via commandline.
JUDGER="$1"
LANG="$2"
ACTION="$3"
STDOUT="$4"
CODEFILE="$5"
COMPILED_CODE="$6"
CODEFILE_PATH="$7"
STDIN="$8"
JAIL="$9"

# Prepare command to be run in chroot jail.
CMD="$JUDGER $LANG $ACTION $STDOUT $CODEFILE $COMPILED_CODE $CODEFILE_PATH $STDIN"

chroot $JAIL /bin/bash -c "$CMD"