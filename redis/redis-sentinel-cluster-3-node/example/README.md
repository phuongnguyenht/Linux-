Redis Sentinel High Availability Setup
===================


Follow this procedure to setup a High Available Redis Caching Layer.

### Environment

 1. haproxy
 2. redis
 3. redis-sentinel
 
```
Node1: 192.168.12.132 (Master)
Node2: 192.168.12.134 (Slave)
Node3: 192.168.12.131 (Slave)

```

Ta sử dụng cấu hình file /etc/sysctl.conf trên 3 node như sau:
```
# sysctl settings are defined through files in
# /usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.
#
# Vendors settings live in /usr/lib/sysctl.d/.
# To override a whole file, create a new file with the same in
# /etc/sysctl.d/ and put new settings there. To override
# only specific settings, add a file with a lexically later
# name in /etc/sysctl.d/ and put new settings there.
#
# For more information, see sysctl.conf(5) and sysctl.d(5).


#Disable slow start
net.ipv4.tcp_slow_start_after_idle=0
net.core.wmem_max=12582912
net.core.wmem_default = 2048000
net.core.rmem_max=12582912

net.core.optmem_max=25165824
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_rmem=10240 87380   12582912
net.ipv4.udp_mem=10240 87380   12582912
net.ipv4.tcp_wmem=102400 2048000        12582912
net.ipv4.tcp_mem=196608 262144  393216
net.ipv4.tcp_congestion_control=scalable
#no metrics -> avoid confuse for user behind NAT
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_moderate_rcvbuf = 1
#enable fast open
#net.ipv4.tcp_fastopen=1
net.ipv4.tcp_frto=1
net.ipv4.tcp_low_latency=1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 0


#flush cache of ssth
net.ipv4.route.flush=1
net.ipv4.tcp_adv_win_scale=1
#Add more local port
net.ipv4.ip_local_port_range = 1024   61000
net.ipv4.tcp_fin_timeout = 10
#Change keep alive in Linux
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 20
net.ipv4.tcp_keepalive_probes = 10
#Increase network buffer
net.core.netdev_max_backlog = 300000
net.ipv4.tcp_congestion_control = cubic
net.core.somaxconn = 50000
fs.file-max = 9400000

#Fixing CVE-2016-5696 vulnerability
net.ipv4.tcp_challenge_ack_limit = 999999999
```