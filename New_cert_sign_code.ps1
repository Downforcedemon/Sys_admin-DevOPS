# Define certificate parameters
$certParams = @{
    KeyUsage = 'DigitalSignature'
    KeySpec = 'Signature'
    KeyAlgorithm = 'RSA'
    KeyLength = 4096
    DnsName = '<server-name>'
    CertStoreLocation = 'Cert:\LocalMachine\my'
    Type = 'CodeSigningCert'
    Subject = 'Test2SignCert'
}

# Create a self-signed code signing certificate
$cert2 = New-SelfSignedCertificate @certParams

# Export the certificate to a .cer file
$certificateFilePath = "C:\Certificates\TestSignCert.cer"
$cert2 | Export-Certificate -FilePath $certificateFilePath -Force

# Sign the code using the code signing certificate
$scriptPath = "C:\Users\Administrator\Downloads\filename.ps1"
Set-AuthenticodeSignature -FilePath $scriptPath -Certificate $cert2 -TimestampServer "http://timestamp.digicert.com"

# Install the certificate into the Trusted Root Certification Authorities store
Import-Certificate -FilePath $certificateFilePath -CertStoreLocation Cert:\LocalMachine\Root

Write-Host "Certificate created, script signed, and certificate installed in the root store."
