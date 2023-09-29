# Prompt the user for administrator credentials
$adminCreds = Get-Credential -Message "Enter Administrator Credentials"

## Disallow autoplay
# Define the Registry key path for the AutoPlay policy
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

# Define the name of the registry value to set
$valueName = "NoAutoplayfornonVolume"

# Define the value to set (1 for Enabled)
$valueData = 1

# Check if the registry key path exists, and if not, create it
if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the registry value to "Enabled"
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output a message indicating that the policy has been configured
Write-Host "AutoPlay policy 'Disallow Autoplay for nonvolume devices' is now set to 'Enabled'."

## disable autorun
# Define the Registry key path for the AutoRun policy
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

# Define the name of the registry value to set
$valueName = "NoDriveTypeAutoRun"

# Define the value to set (0xFF means "Do not execute any autorun commands")
$valueData = 0xFF

# Check if the registry key path exists, and if not, create it
if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the registry value to "Enabled" with "Do not execute any autorun commands"
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output a message indicating that the AutoRun policy has been configured
Write-Host "AutoRun policy set to 'Enabled' with 'Do not execute any autorun commands' selected."

## Disable auto-play for cd/rom
# Define the registry key path for Group Policy settings
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

# Define the name of the registry value to set
$valueName = "NoDriveTypeAutoRun"

# Define the value to set (0xFF means "Turn off AutoPlay for all drives")
$valueData = 0xFF

# Check if the registry key path exists, and if not, create it
if (-not (Test-Path -Path $policyPath)) {
    New-Item -Path $policyPath -Force
}

# Set the registry value to "Enabled" with "All Drives" selected
Set-ItemProperty -Path $policyPath -Name $valueName -Value $valueData

# Output a message indicating that the AutoPlay policy has been configured
Write-Host "AutoPlay policy set to 'Enabled' with 'All Drives' selected."

## elevated privileges required for installer
# Import the GroupPolicy module if not already loaded
if (-not (Get-Module -Name GroupPolicy -ListAvailable)) {
    Import-Module GroupPolicy
}

# Define the name of the Group Policy setting
$policyName = "Always install with elevated privileges"

# Disable the Group Policy setting
Set-GPRegistryValue -Name "Local Group Policy" -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer" -ValueName "AlwaysInstallElevated" -Type DWord -Value 0

# Output a message indicating that the policy has been configured
Write-Host "$policyName policy set to 'Disabled'."

## WinRM not to use basic authentication
# Import the GroupPolicy module if not already loaded
if (-not (Get-Module -Name GroupPolicy -ListAvailable)) {
    Import-Module GroupPolicy
}

# Define the name of the Group Policy setting
$policyName = "Allow Basic authentication"

# Disable the Group Policy setting
Set-GPRegistryValue -Name "Local Group Policy" -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" -ValueName "AllowBasic" -Type DWord -Value 0

# Output a message indicating that the policy has been configured
Write-Host "$policyName policy set to 'Disabled'."

## WinRM service not to use basic auth
# Import the GroupPolicy module if not already loaded
if (-not (Get-Module -Name GroupPolicy -ListAvailable)) {
    Import-Module GroupPolicy
}

# Define the name of the Group Policy setting
$policyName = "Allow Basic authentication"

# Disable the Group Policy setting
Set-GPRegistryValue -Name "Local Group Policy" -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -ValueName "AllowBasic" -Type DWord -Value 0

# Output a message indicating that the policy has been configured
Write-Host "$policyName policy set to 'Disabled'."

## disable enumeration of shares with auth
# Define the Registry key path for the security policy
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "RestrictAnonymous"
$expectedValue = 1  # Expected value as specified

# Check if the registry value exists
if (Test-Path -Path "$registryPath\$valueName") {
    # Get the current value
    $currentValue = (Get-ItemProperty -Path "$registryPath\$valueName").$valueName

    # Check if the current value matches the expected value
    if ($currentValue -eq $expectedValue) {
        Write-Host "The registry value '$valueName' is configured as specified."
    } else {
        Write-Host "The registry value '$valueName' exists but is not configured as specified."
    }
} else {
    # Create the registry value with the expected value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue -Type DWORD

    Write-Host "The registry value '$valueName' did not exist and has been created with the specified value."
}

## Only allow NTLMv2
# Define the Registry key path for the security policy
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "LmCompatibilityLevel"
$expectedValue = 5  # Expected value as specified

# Check if the registry value exists
if (Test-Path -Path "$registryPath\$valueName") {
    # Get the current value
    $currentValue = (Get-ItemProperty -Path "$registryPath\$valueName").$valueName

    # Check if the current value matches the expected value
    if ($currentValue -eq $expectedValue) {
        Write-Host "The registry value '$valueName' is configured as specified."
    } else {
        Write-Host "The registry value '$valueName' exists but is not configured as specified."
    }
} else {
    # Create the registry value with the expected value
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue -Type DWORD

    Write-Host "The registry value '$valueName' did not exist and has been created with the specified value."
}



# Add a general confirmation message indicating that all scripts were successfully executed
Write-Host "All scripts were successfully executed."

##  local volumes must use a format that supports NTFS attributes.
  # Get all local volumes excluding system partitions (Recovery and EFI System Partition)
$volumes = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 -and $_.DeviceID -notmatch "^C:" }

# Loop through each volume and check the file system
foreach ($volume in $volumes) {
    $volumeLetter = $volume.DeviceID
    $fileSystem = (Get-Volume -DriveLetter $volumeLetter).FileSystemType

    # Check if the file system is neither NTFS nor ReFS
    if ($fileSystem -ne "NTFS" -and $fileSystem -ne "ReFS") {
        Write-Host "Volume $($volume.DeviceID) has an unsupported file system: $fileSystem (This is a finding)."
    }
    else {
        Write-Host "Volume $($volume.DeviceID) has a supported file system: $fileSystem (This is acceptable)."
    }
}

## Disable reversible encryption
# Set the registry key for the policy
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name "StorePasswordAsReversibleHash" -Value 0

# Force a policy update
gpupdate /force

Write-Host "The 'Store passwords using reversible encryption' policy has been set to 'Disabled'."

## NTDS permissions
# Define the paths to NTDS database and log files
$ntdsDatabasePath = "C:\Windows\NTDS\ntds.dit"
$ntdsLogPath = "C:\Windows\NTDS"

# Set permissions for NT AUTHORITY\SYSTEM and BUILTIN\Administrators
$permissions = "NT AUTHORITY\SYSTEM:(I)(F)", "BUILTIN\Administrators:(I)(F)"

# Apply permissions to NTDS database
icacls.exe $ntdsDatabasePath /grant:r ($permissions -join ',') /T

# Apply permissions to NTDS log files
icacls.exe $ntdsLogPath /grant:r ($permissions -join ',') /T

Write-Host "Permissions on NTDS database and log files have been set as specified."

## prevent local accounts with blank password from using the network
# Define the security option name
$securityOption = "Limit local account use of blank passwords to console logon only"

# Set the security option to "Enabled"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 1

# Verify the change
$enabledValue = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").LimitBlankPasswordUse

if ($enabledValue -eq 1) {
    Write-Host "The '$securityOption' policy has been set to 'Enabled'."
} else {
    Write-Host "Failed to set the '$securityOption' policy to 'Enabled'."
}

## disable anonymous enumeration of Security Account Manager (SAM) accounts
# Define the security option name
$securityOption = "Network access: Do not allow anonymous enumeration of SAM accounts"

# Set the security option to "Enabled"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictAnonymousSAM" -Value 1

# Verify the change
$enabledValue = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters").RestrictAnonymousSAM

if ($enabledValue -eq 1) {
    Write-Host "The '$securityOption' policy has been set to 'Enabled'."
} else {
    Write-Host "Failed to set the '$securityOption' policy to 'Enabled'."
}

## restrict anonymous access to Named Pipes and Shares
# Define the security option name
$securityOption = "Network access: Restrict anonymous access to Named Pipes and Shares"

# Set the security option to "Enabled"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess" -Value 1

# Verify the change
$enabledValue = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters").RestrictNullSessAccess

if ($enabledValue -eq 1) {
    Write-Host "The '$securityOption' policy has been set to 'Enabled'."
} else {
    Write-Host "Failed to set the '$securityOption' policy to 'Enabled'."
}

##   prevent the storage of the LAN Manager hash of passwords.
# Define the security option name
$securityOption = "Network security: Do not store LAN Manager hash value on next password change"

# Set the security option to "Enabled"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "NoLMHash" -Value 1

# Verify the change
$enabledValue = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").NoLMHash

if ($enabledValue -eq 1) {
    Write-Host "The '$securityOption' policy has been set to 'Enabled'."
} else {
    Write-Host "Failed to set the '$securityOption' policy to 'Enabled'."
}

##operating system user right
# Define the user right assignment name
$userRight = "SeTcbPrivilege" # "Act as part of the operating system"

# Clear any existing entries for the user right assignment
Secedit.exe /areas User_Rights /p /remove:$userRight

Write-Host "The '$userRight' user right assignment has been cleared (no entries)."
 
## token object user right
# Define the user right assignment name
$userRight = "SeCreateTokenPrivilege" # "Create a token object"

# Clear any existing entries for the user right assignment
Secedit.exe /configure /cfg "%windir%\security\templates\setup security.inf" /areas User_Rights /p /remove:$userRight

Write-Host "The '$userRight' user right assignment has been cleared (no entries)."

## debug programs user right assigned to the Administrators 
# Define the user right assignment name
$userRight = "SeDebugPrivilege" # "Debug programs"

# Define the group to grant the user right (e.g., Administrators)
$groupToGrant = "Administrators"

# Define the full path to your security template file (replace with your actual path)
$templateFilePath = "C:\Users\Administrator\Documents\Security\Templates\Template.inf"

# Configure the user right assignment to include the specified group
secedit.exe /configure /cfg $templateFilePath /areas User_Rights /p /user:$userRight="$groupToGrant"

Write-Host "The '$userRight' user right assignment has been configured to include the '$groupToGrant' group."



