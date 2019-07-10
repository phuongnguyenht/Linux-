IPTABLES NOTE
Sau khi cài Iptables 
yum install iptables-services -y
Centos 6:
mv /etc/init.d/iptables /etc/init.d/iptables.stop

Centos 7: Centos 7 không có file iptables trong folder /etc/init.d/
```
# Type the following command to stop the FirewallD service:
sudo systemctl stop firewalld
# Disable the FirewallD service to start automatically on system boot:
sudo systemctl disable firewalld

Tao file iptables.stop nhu trong file ini.d 
mv /usr/libexec/iptables/iptables.init to /usr/libexec/iptables/_iptables.init
Thêm file service
/usr/lib/systemd/system/iptables.service
[Unit]
Description=IPv4 firewall with iptables
Before=ip6tables.service
After=syslog.target
#AssertPathExists=/etc/sysconfig/iptables

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/etc/init.d/iptables
ExecStop=/etc/init.d/iptables.stop stop
Environment=BOOTUP=serial
Environment=CONSOLETYPE=serial
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=basic.target
~
```



