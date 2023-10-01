# Define the path to your certificate file (.cer or .pfx)
$certificateFilePath = "C:\Certificates\TestSignCert2.cer"

# Load the certificate
$cert = Get-PfxCertificate -FilePath $certificateFilePath

# Check certificate validity
if ($cert.NotAfter -lt (Get-Date)) {
    Write-Host "Certificate has expired. Validity end date: $($cert.NotAfter)"
} else {
    Write-Host "Certificate is valid until: $($cert.NotAfter)"
}

# Check Enhanced Key Usages (EKUs)
$codeSigningEku = New-Object System.Security.Cryptography.Oid("1.3.6.1.5.5.7.3.3")  # Code Signing OID
$ekus = $cert.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Enhanced Key Usage" } | ForEach-Object { $_.Format(0) }
if ($ekus -contains $codeSigningEku.Value) {
    Write-Host "Certificate has 'Code Signing' Enhanced Key Usage."
} else {
    Write-Host "Certificate does not have 'Code Signing' Enhanced Key Usage."
}

# Check certificate store location
$certStoreLocation = $cert.Store.Location
if ($certStoreLocation -eq "LocalMachine") {
    Write-Host "Certificate is in the 'LocalMachine' store."
} elseif ($certStoreLocation -eq "CurrentUser") {
    Write-Host "Certificate is in the 'CurrentUser' store."
} else {
    Write-Host "Certificate is in an unknown store location: $certStoreLocation"
}

# Check private key access
try {
    $privateKey = $cert.PrivateKey
    Write-Host "Private key is accessible."
} catch {
    Write-Host "Private key is not accessible. Error: $_"
}

# Check if the certificate is suitable for code signing
if ($ekus -contains $codeSigningEku.Value -and $privateKey -ne $null) {
    Write-Host "The certificate is suitable for code signing."
} else {
    Write-Host "The certificate is not suitable for code signing."
}
