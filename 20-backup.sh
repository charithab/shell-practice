#!/bin/bash

# find whether variables(source dir, dest dir) are not less than 2
# find whether source directory exists or not
# find whether destination directory exists or not
# check whether files are present in source dire
# zip the files
# take backup or move the zip file to destination dir
# remove the files in source dir

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FOLDER=/var/log/shellscript-logs
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=$(3:-14) # If days are provided(i.e., $3) then it will be considered, otherwise default will be 14 days

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
            echo -e "$2 is... $G SUCCESS $N" | tee - a $LOG_FILE
        else
            echo -e "$2 is... $R FAILURE $N" | tee - a$LOG_FILE
            exit 1
        fi
}
USAGE() {
    echo "sudo sh 20-backup.sh <SOURCE-DIRECTORY> <DESTINATION-DIRECTORY> <DAYS(Optional)>"
    exit 1
}
if [ $# -lt 2 ]
    then    
        USAGE 
fi

if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source Directory $SOURCE_DIR does not exist. Please check $N"
    exit 1
fi

if [ ! -d $DEST_DIR]
then
    echo -e "$R Destination Directory $DEST_DIR does not exist. Please check $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if  [ ! -f $FILES ]
then 
    echo -e "$R No log files Present in Source Directory $SOURCE_DIR $N" | tee -a $LOG_FILE
fi

sudo dnf install zip -y

if [ ! -z "$FILES" ]
then 
    echo "Files to zip are: $FILES"
    TIMESTAMP=$(date +%F-%H-%M-%S)
    ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE"
    if [ -f $ZIP_FILE ]
        then
            echo -e "$G Successfully $N created zip file"

            while IPS= read -r filepath
            do
                echo "Deleting log files: $filepath"
                rm -rf $filepath
            done <<< $FILES
            echo -e "log files older then 14 days from source directory are... $G Removed $N"
    else    
        echo -e "Zip file creation.. $R FAILURE $N"
        exit 1
    fi
else
    echo -e "No log files older than 14 days... $Y SKIPPING $N" | tee -a $LOG_FILE
fi