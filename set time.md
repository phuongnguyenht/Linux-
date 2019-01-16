```
ln -f -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

date -s "2018-11-23 11:30:30"
or
timedatectl set-time '2018-11-23 11:30:30'

yum install -y ntp && ntpdate pool.ntp.org && systemctl enable ntpd && systemctl start ntpd
ntpdate asia.pool.ntp.org

Set date from the command line
date +%Y%m%d -s "20120418"

Set time from the command line
date +%T -s "11:14:00"
```

