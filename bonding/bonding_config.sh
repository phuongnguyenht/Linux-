* * * * * -- Bonding 4 card mạng thành 2 cặp bonding -- * * * * *  

bond0 card 1G Media. bond1 card 10G cho LAN Local
bond0 card 10G LAN.   10.98.0.0/24		mode 1
bond0 card 1G  Media. 10.144.40.64/26	mode 4

Bước 1: Load module bonding
$ modprobe --first-time bonding
$ modinfo bonding

Bước 2: Tạo bond channel
B1. bonding card mạng eno1 và eno2:

# vi /etc/sysconfig/network-scripts/ifcfg-bond0

-- Add the following lines.

DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.144.40.76
GATEWAY=10.144.40.65
NETMASK=255.255.255.192
USERCTL=no
BONDING_OPTS="mode=4 miimon=100"

### --- Notes: Nếu dùng mode khác thì thay giá trị trong cấu hình ở bên trên ( đã test thử các mode chạy ổn: mode=1,4,5,6)
-- Tao file /etc/modprobe.d/bonding.conf va add thêm dòng dưới:
vi /etc/modprobe.d/bonding.conf 
alias bond0 bonding
alias bond1 bonding

-- Chỉnh sửa các file sau:
Edit file /etc/sysconfig/network-scripts/ifcfg-eno1,
# vi /etc/sysconfig/network-scripts/ifcfg-eth1

vi /etc/sysconfig/network-scripts/ifcfg-eno1
Modify the file as shown below.
DEVICE=eno1
MASTER=bond0
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

Then Edit file /etc/sysconfig/network-scripts/ifcfg-eno2,
# vi /etc/sysconfig/network-scripts/ifcfg-eth2
vi /etc/sysconfig/network-scripts/ifcfg-eno2
Modify the file as shown below.
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
IPADDR=10.98.0.16
NETWORK=10.98.0.0
NETMASK=255.255.255.0
USERCTL=no
BONDING_OPTS="mode=1 miimon=100"

-- Chỉnh sửa các file sau:
Edit file /etc/sysconfig/network-scripts/ifcfg-ens3f0,
vi /etc/sysconfig/network-scripts/ifcfg-ens1f0
Modify the file as shown below.
DEVICE=ens1f0
MASTER=bond1
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none

Then Edit file /etc/sysconfig/network-scripts/ifcfg-ens3f1,
vi /etc/sysconfig/network-scripts/ifcfg-ens1f1
Modify the file as shown below.
DEVICE=ens1f1
MASTER=bond1
SLAVE=yes
USERCTL=no
ONBOOT=yes
BOOTPROTO=none
-- Sua file /etc/modprobe.d/bonding.conf va add thêm  dòng dưới: ( cho phép cấu hình 2 bond0 và bond1)
alias bond1 bonding

-- Enter the following command to load the bonding module.
# modprobe bonding
-- Restart network service to take effect the changes.
# service network restart
systemctl restart network

B3. Kiểm tra:
-- Dùng lệnh dưới để kiểm tra trạng thái của 2 bonding
cat /proc/net/bonding/bond0
cat /proc/net/bonding/bond1

# Cách kiểm tra tính đúng đăn của cấu hình bằng cách:
Thử rút 1 dây mạng và quan sát Linux tự động failover NIC từ ens1f0 sang ens1f1 và ngược lại. 
Log của quá trình này được ghi ra syslog /var/log/messages

# NOTE: mode của bond có thể là 1 trong các lựa chọn sau:

mode = 1: active - backup
mode = 2: balance - xor
mode = 3: broadcast
mode = 4: 802.3ad
mode = 5: balance - tlb
mode = 6: balance - alb
miimon: là giá trị tính bằng milisecond (ms) chỉ thời gian giám sát MII của NIC.

# mode=0 (balance-rr)
Round-robin policy: It the default mode. It transmits packets in sequential order from the first available slave through the last. 
This mode provides load balancing and fault tolerance.
# mode=1 (active-backup)
Active-backup policy: In this mode, only one slave in the bond is active. The other one will become active, only when the active slave fails.
The bond’s MAC address is externally visible on only one port (network adapter) to avoid confusing the switch. This mode provides fault tolerance.
# mode=2 (balance-xor)
XOR policy: Transmit based on [(source MAC address XORd with destination MAC address) modulo slave count]. 
This selects the same slave for each destination MAC address. This mode provides load balancing and fault tolerance.
# mode=3 (broadcast)
Broadcast policy: transmits everything on all slave interfaces. This mode provides fault tolerance.
# mode=4 (802.3ad)
IEEE 802.3ad Dynamic link aggregation. Creates aggregation groups that share the same speed and duplex settings. 
Utilizes all slaves in the active aggregator according to the 802.3ad specification.
Prerequisites:
- Ethtool support in the base drivers for retrieving the speed and duplex of each slave.
- A switch that supports IEEE 802.3ad Dynamic link aggregation. Most switches will require some type of configuration to enable 802.3ad mode.
# mode=5 (balance-tlb)
Adaptive transmit load balancing: channel bonding that does not require any special switch support. 
The outgoing traffic is distributed according to the current load (computed relative to the speed) on each slave. 
Incoming traffic is received by the current slave. If the receiving slave fails, another slave takes over the MAC address of the failed receiving slave.
Prerequisite:
- Ethtool support in the base drivers for retrieving the speed of each slave.
# mode=6 (balance-alb)
Adaptive load balancing: includes balance-tlb plus receive load balancing (rlb) for IPV4 traffic, and does not require any special switch 
support. The receive load balancing is achieved by ARP negotiation. The bonding driver intercepts the ARP Replies sent by the local system 
on their way out and overwrites the source hardware address with the unique hardware address of one of the slaves in the bond 
such that different peers use different hardware addresses for the server.
