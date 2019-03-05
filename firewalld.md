#   -- Note Sử dụng firewalld on centos 7 --


1. Show rule active 

```
firewall-cmd --get-active-zones
show rule trong zone default
firewall-cmd --list-all
show rule zone chỉ định
firewall-cmd --zone="zone_name" --list-all

```
2. Create zone và add source 
```
firewall-cmd --permanent --new-zone zone_name
firewall-cmd --permanent --zone="zone_name" --add-source="10.84.10.0/24"
```
3. Tạo rule cho zone 
```
firewall-cmd --permanent --zone="zone_name" --add-service=http
firewall-cmd --permanent --zone="zone_name" --add-port=22/tcp
```
4. Nhớ reload firewalld để ăn cấu hình
```
firewall-cmd --reload
```