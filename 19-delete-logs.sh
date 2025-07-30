#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SOURCE_DIR=/home/ec2-user/app_logs

mkdir -p $LOGS_FOLDER

if [ $USERID -ne 0 ]
    then
        echo -e "$R ERROR: Please run this script with root access $N" | tee -a $LOG_FILE
        exit 1
    else
        echo "You are running with root access" | tee -a $LOG_FILE
fi

VALIDATE() {
    if [ $1 -eq 0 ]
        then
            echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
        else
            echo -e "$2 is... $R FAILURE $N" | tee -a $LOG_FILE
            exit 1
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)

while IPS= read -r filepath
do
    echo "Deleting log file path: $filepath" | tee -a $LOG_FILE
    rm -rf $filepath
done <<< $FILES_TO_DELETE

echo "Script executed successfully"