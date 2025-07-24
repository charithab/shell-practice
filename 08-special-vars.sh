#!/bin/bash

echo "All variables passed to script: $@"
echo "Number of variables: $#"
echo "script name: $0"
echo "Present Working Directory: $PWD"
echo "User directory: $USER"
echo "Home Directory of the user who is running the script: $HOME"
echo "PID of the current directory: $$"
sleep 10 &
echo "PID of the last background command: $!"