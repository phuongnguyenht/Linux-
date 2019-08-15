
B2. bonding card mạng eno1 và eno2:
vi /etc/sysconfig/network-scripts/ifcfg-bond0

DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.144.40.78
GATEWAY=10.144.40.65
NETMASK=255.255.255.192
USERCTL=no
BONDING_OPTS="mode=4 miimon=100"

vi /etc/sysconfig/network-scripts/ifcfg-eno1
DEVICE=eno1
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

vi /etc/sysconfig/network-scripts/ifcfg-eno2
DEVICE=eno2
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

# Chú ý: slave = yes và master = bond0
-- Enter the following command to load the bonding module.
# modprobe bonding
-- Restart network service to take effect the changes.
# service network restart

B2. bonding card mạng eno3 và eno4:
vi /etc/sysconfig/network-scripts/ifcfg-bond1

DEVICE=bond1
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.98.0.18
NETWORK=10.98.0.0
NETMASK=255.255.255.0
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"

vi /etc/sysconfig/network-scripts/ifcfg-ens2f0
DEVICE=ens2f0
MASTER=bond1
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

vi /etc/sysconfig/network-scripts/ifcfg-ens2f1
DEVICE=ens2f1
MASTER=bond1
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

vi /etc/modprobe.d/bonding.conf 
alias bond0 bonding
alias bond1 bonding

systemctl restart network

B3. Kiểm tra:
-- Dùng lệnh dưới để kiểm tra trạng thái của 2 bonding
cat /proc/net/bonding/bond0
cat /proc/net/bonding/bond1

# Cách kiểm tra tính đúng đăn của cấu hình bằng cách:
Thử rút 1 dây mạng và quan sát Linux tự động failover NIC từ ens1f0 sang ens1f1 và ngược lại. 
Log của quá trình này được ghi ra syslog /var/log/messages


