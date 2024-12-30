# enable AD module
Import-Module ActiveDirectory

# user New-ADUser cmdlet
Get-command New-ADUser -Syntax
New-ADUser Singh Simran

# add users
Get-ADUser -Filter * -Properties samAccountName | Select-Object samAccountName

#enable account with attributes
New-AdUser 
-Name "Singh Simran"
-GivenName "Simran"
-SurName "Singh"
-SamAccountName "Singh Simran"
-UserPrincipalname "singh_simran@sever1.com"
-Path "OU=IT,DC=server1,DC=com"
-AccountPassword(Read-Host -AsSecureString "Input Password")
-Enabled $true


