#!/bin/sh
# Description: Thiet lap mat khau manh doi voi tai khoan OS
# Author: Phuongnguyen

echo "Tim account dang hoat dong tren he thong"
awk  -F: '( $1 == "") {print}' /etc/passwd
echo "Tim account co mat khau trong, chua dat mat khau"
awk  -F: '( $2 == "") {print}' /etc/shadow
echo "Dam bao chi co account root co UID = 0 neu tai khoan nao co UID =0 la ngay voi root trong he thong"
awk  -F: '( $3 == "0") {print}' /etc/passwd