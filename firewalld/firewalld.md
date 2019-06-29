#   -- Note Sử dụng firewalld on centos 7 --

1. Show rule active 

```
-- kiểm tra firewall có running hay không 
firewall-cmd --state
-- show zone
firewall-cmd --get-active-zones
firewall-cmd --list-all-zones | less
-- show zone default, rule trong zone default
firewall-cmd --get-default-zone
firewall-cmd --list-all
-- show rule zone chỉ định
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