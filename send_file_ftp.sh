#!/bin/bash

HOST="x.x.x.x"
USER="user"
PASSWD="password"

#path to folder have file send to server ftp
cd /path/x/
sleep 1
FILE=`ls -t *.txt| head -1`

ftp -n $HOST << EOF
quote USER $USER
quote PASS $PASSWD
put $FILE
EOF
