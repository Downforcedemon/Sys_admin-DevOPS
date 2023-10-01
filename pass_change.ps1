# Prompt the user for the username (SamAccountName)
$username = Read-Host "Enter the username (SamAccountName) of the user"

# Search Active Directory for the specified user  # logon name
$user = Get-ADUser -Filter {SamAccountName -eq $username} -Properties Enabled, PasswordNeverExpires, EmailAddress, "msDS-UserPasswordExpiryTimeComputed", "LockedOut"

if ($user -eq $null) {
    Write-Host "User with username $username not found in Active Directory"
}
else {
    Write-Host "User Information for $username`n"
    
    # Check if the account is enabled or disabled
    if ($user.Enabled -eq $true) {
        Write-Host "Account Status: Enabled"
    }
    else {
        Write-Host "Account Status: Disabled"
    }
    
    # Check if the password never expires
    if ($user.PasswordNeverExpires -eq $true) {
        Write-Host "Password Never Expires: Yes"
    }
    else {
        Write-Host "Password Never Expires: No"
    }

    # Get the password expiry date
    $passwordExpiryDate = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")
    Write-Host "Password Expiry Date: $($passwordExpiryDate.ToString("yyyy-MM-dd HH:mm:ss"))"

    # Check if the account is locked
    if ($user.LockedOut -eq $true) {
        Write-Host "Account Locked: Yes"
        $unlock = Read-Host "Do you want to unlock this account? (y/n)"
        if ($unlock -eq "y" -or $unlock -eq "Y") {
            # Attempt to unlock the account
            Unlock-ADAccount -Identity $user
            Write-Host "Account unlocked successfully."
        }
        else {
            Write-Host "Account remains locked."
        }
    }
    else {
        Write-Host "Account Locked: No"
    }
    
    # Get the email address from UserPrincipalName
    $emailAddress = $user.UserPrincipalName
    Write-Host "Email Address: $emailAddress"


# Prompt to change the password
    $changePassword = Read-Host "Do you want to change the password for this user? (y/n)"
    if ($changePassword -eq "y" -or $changePassword -eq "Y") {
        # Prompt for and securely input the new password
        $newPassword = Read-Host "Enter the new password" -AsSecureString

        # Set the new password for the user
        Set-ADAccountPassword -Identity $user -NewPassword $newPassword -Reset
        Write-Host "Password changed successfully."
    }
    else {
        Write-Host "Password remains unchanged."
    }

    } 
