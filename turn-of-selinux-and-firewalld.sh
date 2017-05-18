#!/bin/bash

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

$NUM =`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'`
