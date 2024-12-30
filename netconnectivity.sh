#!/bin/bash
# the purpose is to combine ping,traceroute,nmap to test connectivity

# define the target host
echo "Enter the target hostname or IP address:"
read target
echo "Testing connectivity to $target"

#ping test
ping -c 4 -v "$target"  | sed -n '3,6p;6q;d'
if [ $? -eq 0 ]; then 
echo "Target alive"
else
echo "Target asleep"
fi

#Traceroute test with verbose output
echo "Traceroute test:"
traceroute -n "$target"
if [ $? -eq 0 ]; then
echo "Target alive"
else
echo "Target asleep"
fi 

#nmap scan with verbose ouput
echo "Nmap scan:"
nmap -v -Pn -p 1-1000 "$target"
if [$? -eq 0 ]; then
echo "Nmap scan: Target has open ports"
else
echo "Nmap scan: Target has no open ports"
fi

