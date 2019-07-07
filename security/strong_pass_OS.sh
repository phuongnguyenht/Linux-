#!/bin/sh
# Description: Thiet lap mat khau manh doi voi tai khoan OS
# Author: Phuongnguyen

file="/etc/pam.d/system-auth.bak"
if [ -f "$file" ]
then
	echo "$file found."
else
	echo "$file not found."
	cp /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
	cd /etc/pam.d/
	echo "password    requisite     pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1" >> system-auth
	authconfig –updateall
fi