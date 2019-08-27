
* * * Yêu cầu, share folder từ 1 server Master tới 1 folder trên Client

Author: Hocnv
Email: hocnv2010@gmail.com

* * * Giả sử có 2 server Master và Client như dưới:


Master: 12.34.56.789
Client: 12.33.44.555

--- #)B1. Cai dat nfs trên cả Master và Client:
yum install -y nfs-utils nfs-utils-lib

Và cho phép khởi động cùng với server:

chkconfig nfs on  (systemctl enable nfs.service)
service rpcbind start (systemctl restart rpcbind.service)
service nfs start     (systemctl restart nfs.service)

--- B#)B2. Cấu hình thư mục chia sẻ, quyền:

Bước tiếp theo là quyết định thư mục nào chúng ta muốn chia sẻ với máy chủ Client. Thư mục được chọn sau đó sẽ được thêm vào tệp /etc/exports, chỉ định cả thư mục được chia sẻ và chi tiết về cách chia sẻ thư mục đó.

Giả sử cần chia sẻ thư mục: /opt/code/tvod2-backend/originVOD 

vim /etc/exports
### Và add vào nội dung ###
/opt/code/tvod2-backend/originVOD               12.33.44.555(rw,sync,no_root_squash,no_subtree_check)


### end ####

Trong đó:

- rw: Tùy chọn này cho phép máy chủ Client cả đọc và ghi trong thư mục được chia sẻ
- sync: Sync xác nhận các yêu cầu tới thư mục được chia sẻ chỉ khi các thay đổi đã được thực hiện.
- no_subtree_check: Tùy chọn này ngăn cản việc kiểm tra subtree. Khi một thư mục chia sẻ là thư mục con của một hệ thống tệp lớn hơn, nfs thực hiện quét mọi thư mục ở trên nó, để xác minh quyền và chi tiết của nó. Vô hiệu hóa kiểm tra subtree có thể làm tăng độ tin cậy của NFS, nhưng giảm an toàn bảo mật.
- no_root_squash: Cụm từ này cho phép root kết nối với thư mục được chỉ định

Sau đó, thực hiện lệnh:
[root@TVoDFeBe01 originVOD]# exportfs -a

--- B3) Thực hiện mount:

Chuẩn bị:
## * * * Thực hiện trên Server * * * * * - * :
##****) Lưu ý: nếu bật iptables thì cần chỉnh lại cấu hình port cho nfs và rpcbind trong file: /etc/sysconfig/nfs
## Phần cấu hình port này được thực hiện trên server
##       Rồi allow port từ iptables thì mới thực hiện mount được
##		Tham khảo: https://www.cyberciti.biz/faq/centos-fedora-rhel-iptables-open-nfs-server-ports/

Cấu hình port như sau:

		# TCP port rpc.lockd should listen on.
		LOCKD_TCPPORT=lockd-port-number
		# UDP port rpc.lockd should listen on.
		LOCKD_UDPPORT=lockd-port-number 
		# Port rpc.mountd should listen on.
		MOUNTD_PORT=mountd-port-number
		# Port rquotad should listen on.
		RQUOTAD_PORT=rquotad-port-number
		# Port rpc.statd should listen on.
		STATD_PORT=statd-port-number
		# Outgoing port statd should used. The default is port is random
		STATD_OUTGOING_PORT=statd-outgoing-port-number

Ví dụ: 
	LOCKD_TCPPORT=32803
	LOCKD_UDPPORT=32769
	MOUNTD_PORT=892
	RQUOTAD_PORT=875
	STATD_PORT=662
	STATD_OUTGOING_PORT=2020
Sau khi cấu hình port xong thì thực hiện:
	service portmap restart
	service nfs restart
	centos 6:
	service rpcsvcgssd restart
	---centos 7
	systemctl restart rpcbind 
	
	systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl restart rpcbind
systemctl restart nfs-server
systemctl restart nfs-lock
systemctl restart nfs-idmap

## Allow for NFS, Rpcbind
	AL_IP_NFS="127.0.0.1 localhost 10.84.5.0/24 10.1.0.20/24 10.1.0.21/24 100.100.48.34 100.100.48.35 100.100.48.32/29"
	for h in $AL_IP_NFS; do
	$IPTABLES -A INPUT -s $h -p tcp --dport 111 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p udp --dport 111 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p tcp --dport 2049 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p tcp --dport 892 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p udp --dport 892 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p tcp --dport 662 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p udp --dport 662 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p tcp --dport 2020 -j ACCEPT
	$IPTABLES -A INPUT -s $h -p udp --dport 2020 -j ACCEPT
	done

Restart lai iptables:
	systemctl restart iptables


## * * * Thực hiện trên Client * * * * * - * :

Tạo folder để nhận mount từ Master:

[root@TVoDTra originVOD]# mkdir -p /opt/code/tvod2_backend/originVOD
[root@TVoDTra originVOD]# mount 12.34.56.789:/opt/code/tvod2-backend/originVOD /opt/code/tvod2_backend/originVOD
[root@TVoDTra originVOD]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             143G  7.7G  128G   6% /
tmpfs                 1.9G   68K  1.9G   1% /dev/shm
12.34.56.789:/opt/code/tvod2-backend/originVOD
                       74G   38G   32G  55% /opt/code/tvod2_backend/originVOD

[root@TVoDTra vod_transcoder]# mount
/dev/sda1 on / type ext4 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)
12.34.56.789:/opt/code/tvod2-backend/originVOD on /opt/code/tvod2_backend/originVOD type nfs (rw,vers=4,addr=10.84.5.185,clientaddr=12.33.44.555)




##) Đảm bảo việc chia sẻ luôn hoạt động ngay cả khi khởi động lại server bằng cách thêm thư mục vào  /ect/fstab trên máy Client:

12.34.56.789:/opt/code/tvod2-backend/originVOD  /opt/code/tvod2_backend/originVOD   nfs      auto,noatime,nolock,bg,nfsvers=3,intr,tcp,actimeo=1800 0 0

##) Sau khi  máy chủ khởi động lại sau đó, bạn có thể sử dụng một lệnh duy nhất để mount các thư mục được chỉ định trong tệp fstab:

[root@TVoDTra vod_transcoder]# mount -a 

##) Muốn bỏ mount, thực hiện lệnh sau:

[root@TVoDTra vod_transcoder]# umount /opt/code/tvod2_backend/originVOD




