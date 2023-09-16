# Install OpenSSH Server Feature
Install-WindowsFeature -Name OpenSSH-Server -IncludeManagementTools

# Start SSH Server
Start-Service sshd

# Copy id_rsa.pub to Windows Server (replace with the actual path)
Copy-Item -Path C:\path\to\your\id_rsa.pub -Destination C:\ProgramData\ssh\id_rsa.pub

# Append id_rsa.pub to administrators_authorized_keys
Add-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value (Get-Content C:\ProgramData\ssh\id_rsa.pub)

# Set permissions on administrators_authorized_keys
icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

# Configure sshd_config
$sshdConfigPath = "C:\ProgramData\ssh\sshd_config"

# enable pubkeyAuthentication
 (Get-Content $sshdConfigPath).Replace("#PubkeyAuthentication yes", "PubkeyAuthentication yes") | Set-Content $sshdConfigPath

# uncomment the following if needed. 
# (Get-Content $sshdConfigPath).Replace("#PasswordAuthentication yes", "PasswordAuthentication no") | Set-Content $sshdConfigPath

# Restart SSH Server
Restart-Service sshd

# Test SSH Connection (replace with the appropriate IP and username)
Test-NetConnection -ComputerName localhost -Port 22

