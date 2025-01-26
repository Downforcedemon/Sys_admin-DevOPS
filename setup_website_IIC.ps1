# step 1 create website
Write-Host "Setp 1: Create a New Website"
$siteName = Read-Host "Enter the name of the website"
$physicalPath = Read-Host "Enter Physical Path (e.g., C:\inetpub\MySite)"
$httpPort = Read-Host "Enter HTTP Port (e.g., 80)"


New-Item -ItemType Directory -Path $physicalPath -Force
New-Website -name $siteName -PhysicalPath $physicalPath -Port $httpPort 
Write-Host "Website '$siteName' created and bound to HTTP on port $httpPort."

# Step 2: Application Pool Configuration
Write-Host "Step 2: Application Pool Configuration"
$appPoolName = Read-Host "Enter the name of the application pool name (or press Enter to use '$siteName' as the app pool name)"
if (-not $appPoolName) {
    $appPoolName = $siteName
}

New-WebAppPool -Name $appPoolName
Set-ItemProperty IIS:\AppPools\$appPoolName -name enable32BitAppOnWin64 -value $true
Write-Host "Application pool $appPoolName created and configured successfully!"
})

# Step 3: HTTPS Binding
Write-Host "Step 3: Configure HTTPS Binding"
$enableHttps = Read-Host "Do you want to add HTTPS Binding? (Yes/No)" -Default "No"
if ($enableHttps -eq "Yes") {
    $thumbprint = Read-Host "Enter SSL Certificate Thumbprint (leave blank to create self-signed)"
    if (-not $thumbprint) {
        $thumbprint = (New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $siteName).Thumbprint
        Write-Host "Self-signed certificate created."
    }
    New-WebBinding -Name $siteName -Protocol "https" -Port 443 -CertificateThumbprint $thumbprint -CertificateStoreName "MY"
    Write-Host "HTTPS Binding added for '$siteName'."
}

# Step 4: Default Documents
Write-Host "Step 4: Configure Default Documents"
$defaultDocument = Read-Host "Enter Default Document (e.g., index.html)"
Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/defaultDocument/files" -Name "value" -Value $defaultDocument
Write-Host "Default document set to '$defaultDocument'."

# Step 5: Enable Logging
Write-Host "Step 5: Enable Logging"
$logPath = Read-Host "Enter Log Directory (e.g., C:\inetpub\logs)" -Default "C:\inetpub\logs"
Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.applicationHost/sites/site[@name='$siteName']/logFile" -Name "directory" -Value $logPath
Write-Host "Logging enabled. Logs will be stored in '$logPath'."

# Step 6: Enable Compression
Write-Host "Step 6: Enable Compression"
$enableCompression = Read-Host "Do you want to enable static and dynamic compression? (Yes/No)" -Default "Yes"
if ($enableCompression -eq "Yes") {
    Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/httpCompression" -Name "staticCompressionEnable" -Value "True"
    Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/httpCompression" -Name "dynamicCompressionEnable" -Value "True"
    Write-Host "Compression enabled for static and dynamic content."
}

