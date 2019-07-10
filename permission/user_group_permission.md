# Note User, Group and Permission for user and group

1. User
```
useradd [options] username

-- Add a new user called jerry to secondary group named cartoons on Linux:
sudo useradd -G cartoons jerry
-- Add a new user called tom to primary group called cartoons:
useradd -g cartoons tom
-- Linux add a existing user named spike to existing group named cartoons:
useradd -g cartoons spike

Example: useradd -m -d /opt/data/ -s /bin/bash -u 1001 -g 1001 data 

2. Group
```
--Create group 
groupadd  newgroup

-- Add user to group
usermod -a -G newgroup username

-- Check info member of group 
cat /etc/group


```
3.Permission 
```
Open file /etc/sudoers

root ALL=(ALL:ALL) ALL

root: account sẽ được áp rule này (ở đây là root)
ALL: Chữ all đầu tiên chỉ ra rằng rule này được áp dụng cho tất cả các host
ALL: chữ all thứ hai chỉ ra, account root có thể chạy lệnh với quyền của bất kỳ user nào.
ALL: chứ all thứ ba chỉ ra, account root có thể chạy lệnh với quyền của bất kỳ group nào.
ALL: chữ all cuối cùng chỉ ra, account root có thể chạy bất kỳ command nào.
Tóm tắt: account root có thể chạy bất kỳ command nào với quyền của bất kỳ user/group nào trên bất kỳ host nào.
%admin ALL=(ALL) ALL

Rule này giống với rule trên, tuy nhiên nó áp dụng cho group (bắt đầu với ký tự %).
Ta có thể mô tả như sau: Group admin có thể thực hiện bất kỳ command nào với quyền của bất kỳ user nào trên bất kỳ host nào.
Tương tự với rule: %sudo ALL=(ALL:ALL) ALL (group sudo có thể thực hiện bất kỳ command nào với quyền của bất kỳ user/group nào trên bất kỳ máy nào)
ALIAS

Bên trên là lý thuyết, chúng ta đã biết về cú pháp của các rule. Giờ chúng ta thử tạo rule cho riêng mình xem sao :). Nhưng trước khi tạo rule, chúng ta tìm hiểu một chút về Alias cái đã.
Alias giúp chúng ta cấu trúc lại các rule rõ ràng hơn thông qua việc group các dữ liệu lại với nhau.
```
4.Ví dụ
```
root    ALL=(ALL)       ALL
phuongnt       ALL=NOPASSWD: /bin/cat *, /usr/bin/tail *, /sbin/service kamailio status, /sbin/service mysqld status, /sbin/service ejabberd status, /sbin/service httpd status, /sbin/service tomcat status, /sbin/service ntpd status, /usr/local/sbin/kamctl online, /usr/local/sbin/kamcmd core.shmmem m, /bin/netstat, /tmp/monitor/*, /home/phuongnt/*, /tmp/monitor/voice_platform_monitor/*, /bin/su, /sbin/service snmpd *, /var/prtg/scripts/*, /bin/vi /etc/snmp/*, /bin/vi snmpd.conf
```