#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Error:: Please run this script with root access"
    exit 1
else
    echo "You are running with root access"
fi

dnf list installed mysql
# check if mysql is installed or not. If installed i.e., $? is 0, then else condition
# If not installed i.e., $? is not 0, then install it.
if [ $? -ne 0 ]
then
    echo "Mysql is not installed...going to install"
    dnf install mysql -y
    if [ $? -eq 0 ]
    then 
        echo "Installing mysql is....SUCCESS"
    else
        echo "Installing mysql is....FAILURE"
        exit 1
    fi

else
    echo "Mysql is already installed..nothing to do"
    exit 1
fi

# dnf install mysql -y

# if [ $? -eq 0 ]
# then 
#     echo "Installing mysql is....SUCCESS"
# else
#     echo "Installing mysql is....FAILURE"
#     exit 1
# fi
