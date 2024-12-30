#!/bin/bash    
#                                                                          
date_time() {
	system_time=$(date + "%T")
	echo "Current time=$system_time"
} 
#cpu usage
cpu_usage() {
	cpuusage=$(mpstat | awk '$12 ~ /[0-9]+/ { print 100 - $12 }' ) 
	echo "cpu usage: $cpuusage%"

# check available disk space on /
disk_space() {
	diskspace=$(df -h /root | awk 'NR==2 {print$4}')                #NR==2 condition, NR is record number, 2 is second line, print is for value of 4th field/column
	echo "disk space in root is: $diskspace"
}

# display the number of logged in users 
logged_users() { 
	loggedusers=$( who | awk '{print $1}')
	echo "current logged in users are: $loggedusers"
}

# prints the memory usage statistics
memory_usage() { 
	memoryusage=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
	echo "memory usage is : $memoryusage"
}