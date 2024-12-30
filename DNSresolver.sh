#!/bin/bash
# the purpose is to automate hostname resolution

# Determine the input and output (hostname/ip)
read -r -p "Enter the hostname: " hostname

# DNS resolver library (dig)
ip_address=$(host "$hostname" | grep -i 'Address:' | tail -n1 | awk '{print $2}')
echo "$ip_address"
# function takes hostname/ip as input or standalong from a list of hostnames

