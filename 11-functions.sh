#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Error:: Please run this script with root access"
    exit 1
else
    echo "You are running with root access"
fi

# validate command takes exit status as input, $1 is exit status input and $2 is argument 2 in validate
VALIDATE(){
if [ $1 -eq 0 ]
    then 
        echo "Installing $2 is....SUCCESS"
    else
        echo "Installing $2 is....FAILURE"
        exit 1
    fi
}

dnf list installed mysql
# check if mysql is installed or not. If installed i.e., $? is 0, then else condition
# If not installed i.e., $? is not 0, then install it.
if [ $? -ne 0 ]
then
    echo "Mysql is not installed...going to install"
    dnf install mysql -y
    VALIDATE $? "MySql"

else
    echo "Mysql is already installed..nothing to do"
fi

dnf list installed nginx

if [ $? -ne 0 ]
then
    echo "nginx is not installed...going to install"
    dnf install nginx -y
    VALIDATE $? "nginx"

else
    echo "nginx is already installed..nothing to do"
fi

dnf list installed python3

if [ $? -ne 0 ]
then
    echo "python3 is not installed...going to install"
    dnf install python3 -y
    VALIDATE $? "python3"

else
    echo "python3 is already installed..nothing to do"
fi