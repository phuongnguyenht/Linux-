#!/bin/bash
#***********************************************************************************
#************************** Show system info ***************************************
#***********************************************************************************

echo "----------------Show serial:----------------------------"
dmidecode -t system | grep "Serial Number:"
echo '        '

echo "----------------Show manufacture------------------------"
dmidecode --type 17 | more | grep "Manufacturer:" | head -1

echo -e ' \t' $(dmidecode -s  system-product-name)
echo '        '

echo "----------------Show CPU info:--------------------------"
cpuinfo=`dmidecode -t processor | grep -i version`
echo -e ' \t' "$cpuinfo"
echo -e ' \t' "So core of CPU:" $(cat /proc/cpuinfo | grep processor | wc -l)
echo '        '

echo "----------------Show info RAM:--------------------------"
echo -e ' \t' "cat /proc/meminfo | grep MemTotal"

rammaximum=`dmidecode -t memory | grep -i "Maximum" | grep "Maximum Capacity:" | head -1`
echo -e ' \t' "Maximum Ram support $rammaximum"

ramtype=`dmidecode --type 17 | more | grep "Type:" | head -1`
slotcamram=`dmidecode -t memory | grep -i "size" | grep MB | wc -l`
echo -e ' \t' "Loai Ram: $ramtype So slot dang dung: $slotcamram"

speed=`dmidecode --type 17 | more | grep "Speed:" | head -1`
echo -e ' \t' "Moi thanh chay voi $speed"
echo '        '

echo "----------------Show info DISK:--------------------------"
# Download: wget http://downloads.linux.hpe.com/SDR/repo/spp/2016.04.0_supspp_rhel6.8_x86_64/hpssacli-2.40-13.0.x86_64.rpm
# Install rpm -ivl hpssacli-2.40-13.0.x86_64.rpm
#hpssacli ctrl all show config
#hpssacli ctrl all show config detail
cat /proc/scsi/scsi
echo '        '

echo "-------------Show power supply hardware------------------"
echo -e ' \t' "So luong nguon: $(dmidecode -t 39 | grep "System Power Supply" | wc -l) -- $(dmidecode -t 39 | grep "Max Power Capacity:" | head -1 | cut -d ":" -f2)"
