# Prompt for the user
$storeNumber = Read-Host -Prompt "Enter the store number to search for"

#Fetch all DHCP Servers in the domain
$dhcpServers = Get-DhcpServerInDC

# Filter results where the dns name contains the store number
$matchingServers = $dhcpServers | Where-Object { $_.dnsName -like "*$storeNumber*" } 

# check if any matches are found
if ($matchingServers) {
    Write-Host "Matching DHCP Servers for Store Number $storeNumber" -ForegroundColor Green
    $matchingServers | Format-Table -AutoSize
} else {
    Write-Host "No DHCP Servers found for store number $storeNumber" -ForegroundColor Red
}