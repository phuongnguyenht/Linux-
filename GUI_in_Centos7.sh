#! /bin/bash

yum groupinstall "GNOME Desktop" -y
systemctl get-default
systemctl set-default graphical.target
systemctl get-default
systemctl isolate graphical.target
