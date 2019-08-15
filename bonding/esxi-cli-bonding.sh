bonding network mode=1 với Esxi, kết nối vào switch 10G để chuẩn bị mang server lên IDC
esxcli network ip connection list
esxcli network ip connection list | grep -i listen
=> = netstat

esxcli network ip neighbor list

esxcli network ip interface ipv4 get
=> show ip
=> set ip tinh
esxcli network ip interface list
=> show all interface
esxcfg-nics -l
=> show interface up
esxcli network ip route ipv4 list
=> show routing
esxcfg-route
=> show default gw

#esxcfg-nics -l => show all interface up:
Name    PCI           Driver      Link Speed     Duplex MAC Address       MTU    Description                   
vmnic0  0000:03:00.00 tg3         Up   1000Mbps  Full   ac:16:2d:70:92:14 1500   Broadcom Corporation NetXtreme BCM5719 Gigabit Ethernet
vmnic1  0000:03:00.01 tg3         Down 0Mbps     Full   ac:16:2d:70:92:15 1500   Broadcom Corporation NetXtreme BCM5719 Gigabit Ethernet
vmnic2  0000:03:00.02 tg3         Down 0Mbps     Full   ac:16:2d:70:92:16 1500   Broadcom Corporation NetXtreme BCM5719 Gigabit Ethernet
vmnic3  0000:03:00.03 tg3         Down 0Mbps     Full   ac:16:2d:70:92:17 1500   Broadcom Corporation NetXtreme BCM5719 Gigabit Ethernet
vmnic4  0000:0a:00.00 tg3         Down 0Mbps     Half   2c:76:8a:5a:7e:9a 1500   Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
vmnic5  0000:0a:00.01 tg3         Down 0Mbps     Half   2c:76:8a:5a:7e:9b 1500   Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
#esxcli network vswitch standard list => This lists all of the vswitches on the host:
   Name: vSwitch0
   Class: etherswitch
   Num Ports: 128
   Used Ports: 14
   Configured Ports: 128
   MTU: 1500
   CDP Status: listen
   Beacon Enabled: false
   Beacon Interval: 1
   Beacon Threshold: 3
   Beacon Required By: 
   Uplinks: vmnic0
   Portgroups: VLAN 1073, VLAN 3600, VLAN 1005, VLAN 1070, VM Network, Management Network
=> chi co vSwitch0
#esxcli network vswitch standard uplink add -u vmnic1 -v vSwitch0 => them interface up vao vswitch, o day la vmnic1:
=> show lai: 
esxcli network vswitch standard list
esxcli network vswitch standard policy failover get -v vSwitch0
=> xem da co vmnic1?
#esxcli network vswitch standard policy failover get -v vSwitch0 => Get the load balancing policy for the vSwitch
https://favoritevmguy.wordpress.com/2015/04/29/change-active-adapters-and-load-balancing-using-esxi-shell/ 




#esxcli network vswitch standard portgroup list => list all portgroup:
Name                  Virtual Switch  Active Clients  VLAN ID
--------------------  --------------  --------------  -------
Management Network    vSwitch0                     1        0
Media_Private_IP_941  vSwitch0                     0      941
VM Network            vSwitch0                     4        0
#esxcli network vswitch standard portgroup add --portgroup-name=duc1 --vswitch-name=vSwitch0 => create portgroup duc1
esxcli network vswitch standard portgroup remove --portgroup-name=duc1 --vswitch-name=vSwitch0
#esxcli network vswitch standard portgroup policy failover get -p duc1
esxcli network vswitch standard add -u vmnic1 -p duc1 

esxcli network vswitch standard add –v=vSwitch1_bond1
esxcli network vswitch standard add –v=vSwitch2_bond4
esxcli network vswitch standard uplink add -u vmnic1 -v vSwitch0
esxcli network vswitch standard uplink add -u vmnic4 -v vSwitch1
esxcli network vswitch standard uplink add -u vmnic5 -v vSwitch1
esxcli network vswitch standard remove --vswitch-name=vSwitch1_bond4
esxcli network vswitch standard policy failover set -l iphash -v vSwitch0
esxcli network vswitch standard policy failover set -l explicit -v vSwitch0


root/sdp@ipec01
vSwitch0 => iphash
vSwitch1 => 1 fail over
[root@localhost:~] esxcli network vswitch standard list
vSwitch0
   Name: vSwitch0
   Class: cswitch
   Num Ports: 5376
   Used Ports: 10
   Configured Ports: 128
   MTU: 1500
   CDP Status: listen
   Beacon Enabled: false
   Beacon Interval: 1
   Beacon Threshold: 3
   Beacon Required By: 
   Uplinks: vmnic3, vmnic2, vmnic1, vmnic0
   Portgroups: Vivas-1Gbps, Media_Private_IP_941, VM Network, Management Network

vSwitch1
   Name: vSwitch1
   Class: cswitch
   Num Ports: 5376
   Used Ports: 5
   Configured Ports: 128
   MTU: 1500
   CDP Status: listen
   Beacon Enabled: false
   Beacon Interval: 1
   Beacon Threshold: 3
   Beacon Required By: 
   Uplinks: vmnic5, vmnic4
   Portgroups: vivas1
[root@localhost:~] 
esxcli network vswitch standard list
esxcli network vswitch standard add -v=vSwitch1
esxcli network vswitch standard uplink add -u vmnic4 -v vSwitch1
esxcli network vswitch standard uplink add -u vmnic5 -v vSwitch1

esxcli network vswitch standard policy failover set -a vmnic0,vmnic1,vmnic2,vmnic3 -v vSwitch0
esxcli network vswitch standard policy failover set -l portid -v vSwitch1
esxcli network vswitch standard policy failover get -v vSwitch0
esxcli network vswitch standard policy failover get -v vSwitch1


esxcli network vswitch standard policy failover set -a vmnic5,vmnic6 -v vSwitch1
###Tao vmk interface:
esxcli network vswitch standard portgroup add --portgroup-name="Management Network vmk1" --vswitch-name=vSwitch1
esxcli network ip interface add --interface-name=vmk1 --portgroup-name="Management Network vmk1"
esxcli network ip interface list
esxcli network ip interface ipv4 set -i vmk1 -I 10.84.5.184 -N 255.255.255.0 -t static
esxcli network ip interface ipv4 set -i vmk1 -t static -g 10.98.0.1 -I 10.98.0.24 -N 255.255.255.0
esxcli network ip interface ipv4 get
esxcfg-route -a 192.168.100.0/24 192.168.0.1

####down up interface vmnic:
esxcli network nic down -n vmnicX
esxcli network nic up -n vmnicX
esxcfg-nics -l

esxcli network vswitch standard policy failover set -a vmnic0,vmnic1 -v vSwitch0