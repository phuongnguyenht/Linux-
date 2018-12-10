#!/bin/bash
# Script to add a user to Linux system
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        echo -e "\n"
        read -p "Enter quota : " quota
        # xac dinh user da ton tai chua
        egrep "^$username" /etc/passwd >/dev/null
        #neu output cua cau lenh tren la 0 thi user da ton tai, la 1 thi user chua ton tai
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                #ma hoa password tu chuoi password nhap vao
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                # lenh create user voi password da duoc ma hoa
                useradd -m -p $pass $username
                #edquota $username
                setquota -u $username  $quota $quota  0 0 -a /home/
                #useradd -m $username |echo $password | passwd $username --stdin
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi