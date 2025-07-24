#!/bin/bash

#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python3" "nginx" "httpd")

mkdir -p $LOGS_FOLDER
echo "script started executing at: $(DATE)"

if [ $USERID -ne 0 ]
then
    echo -e "$R Error:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

VALIDATE(){
if [ $1 -eq 0 ]
    then 
        echo -e "Installing $2 is....$G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "Installing $2 is....$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

# for $PACKAGE in $@  (This is to send the packages as arguments directly instead of giving it in script)
for $PACKAGE in ${PACKAGES[@]}
do
    dnf list installed $PACKAGE &>>LOG_FILE
    if [ $? -ne 0 ]
    then
        echo "$PACKAGE is not installed...going to install" | tee -a $LOG_FILE
        dnf install $PACKAGE -y &>>$LOG_FILE
        VALIDATE $? "$PACKAGE"

    else
        echo "nothing to do $PACKAGE.. $Y already installed $N" | tee -a $LOG_FILE
    fi
done
