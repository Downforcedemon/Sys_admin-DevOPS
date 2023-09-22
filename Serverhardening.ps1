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

