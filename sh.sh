#!/bin/bash
echo "Architecture : $(uname -a)"

echo "CPU physical : $(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)"

echo "vCPU         : $(cat /proc/cpuinfo | grep "processor" | wc -l)"

MEM_INFO=$(free -m | grep Mem | sed "s/ * / /g")
MEMORY_USED=$(echo $MEM_INFO | cut -d ' ' -f3)
MEMORY_TOTAL=$(echo $MEM_INFO | cut -d ' ' -f2)

echo -n "Memory Usage : $MEMORY_USED/$MEMORY_TOTAL""MB "
echo "$(echo "scale=1; 100 * $MEMORY_USED / $MEMORY_TOTAL" | bc )%"

STORAGE_DEVICE_PATH="/dev/sdc"

STORAGE_INFO_HUMAN=$(df -h $STORAGE_DEVICE_PATH | grep $STORAGE_DEVICE_PATH | sed "s/ * / /g")
STORAGE_USED=$(echo $STORAGE_INFO_HUMAN | cut -d ' ' -f3 | sed 's/[^0-9\.]//g')
STORAGE_TOTAL=$(echo $STORAGE_INFO_HUMAN | cut -d ' ' -f2)

echo -n "Disk Usage   : $STORAGE_USED/$STORAGE_TOTAL "

STORAGE_INFO=$(df $STORAGE_DEVICE_PATH | grep $STORAGE_DEVICE_PATH | sed "s/ * / /g")
STORAGE_USED=$(echo $STORAGE_INFO | cut -d ' ' -f3 | sed 's/[^0-9\.]//g')
STORAGE_TOTAL=$(echo $STORAGE_INFO | cut -d ' ' -f2 | sed 's/[^0-9\.]//g')

echo "$(echo "scale=1; 100 * $STORAGE_USED / $STORAGE_TOTAL" | bc)%"

echo "CPU load     : $(uptime | sed 's/ * / /g' | cut -d ' ' -f9 | cut -d ',' -f1)%"
echo "Last boot    : $(uptime --since)"

echo -n "	LVM use      : "	
if [ "$(lsblk | grep lvm | wc -l)" -gt 0 ]
then
	echo "yes"
else
	echo "no"
fi

echo "Connections TCP: $(ss -t -a -h | wc -l)"

echo "User log       : $(who -u | wc -l)"

echo "Network:       : IP $(hostname -I) ($(ip link | grep link/ether | sed 's/ * / /g' | cut -d ' ' -f3))"

