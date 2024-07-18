# This is the bash script that is used for displaying certain system information. It's essentially Gemartin's Code but I did type this out by hand and changed the variable names.

#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU Physical
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# Virtual CPU
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
used_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
total_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')
percentage_ram=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# Disk Storage
used_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
total_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_total += $2} END {printf ("%.1fGb\n"), memory_total/1024}')
percentage_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3} {total+= $2} END {printf("%d"), used/total*100}')

# CPU Load
cpu_load=$(vmstat 1 4 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpu_load)
cpu_fin=$(printf "%.1f" $cpu_op)

# Last Boot
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM Use
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP Connections
tcp_connections=$(ss -ta | grep ESTAB | wc -l)

# User Log
user_log=$(users | wc -w)

# Network
ip_address=$(hostname -I)
mac_address=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO Command
sudo_command=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $arch
	CPU physical: $pcpu
	vCPU: $vcpu
	Memory Usage: $used_ram/${total_ram}MB ($percentage_ram%)
	Disk Usage: $used_disk/${total_disk} ($percentage_disk%)
	CPU load: $cpu_fin%
	Last boot: $last_boot
	LVM use: $lvm_use
	Connections TCP: $tcp_connections ESTABLISHED
	User log: $user_log
	Network: IP $ip_address ($mac_address)
	Sudo: $sudo_command cmd"
