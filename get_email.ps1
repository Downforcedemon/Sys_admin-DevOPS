# List of usernames
$usernames = @(
 "@firstname","@firstname","@firstname"
 )

# Get the desktop path
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputFile = Join-Path -Path $desktopPath -ChildPath "ADUserEmails.txt"

# Initialize an array to store results
$results = @()

foreach ($username in $usernames) {
    # Fetch user information from AD
    $user = Get-ADUser -Filter "SamAccountName -eq '$username'" -Property EmailAddress

    if ($user) {
        $results += "`$username: $($user.EmailAddress)"
    } else {
        $results += "`$username: Not Found"
    }
}

# Write results to the text file
$results | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Email addresses have been exported to $outputFile"
