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

Cài đặt ntpd server
yum -y install ntp

Cài đặt ntpdate client
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/ntpdate-4.2.6p5-28.el7.centos.x86_64.rpm
rpm -ivh ntpdate-4.2.6p5-28.el7.centos.x86_64.rpm

# Crontab update time to NTP server
*/5 * * * *   /usr/sbin/ntpdate -u 10.144.17.227

```

