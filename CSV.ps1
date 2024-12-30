#Enter a path to your import CSV file
$ADUsers = import-csv C:\scripts\nerusers.CSV

foreach ($User in $ADUsers)
{
    $Username = $User.username 
    $password = $User.Password
    $Firstname = $User.$Firstname
    $Lastname = $User.$Lastname
 $Department = $User.$Department
   $OU = $User.OU

   #Check if the user account already exits in AD
   if (Get-ADUser -F {SamAccountName -eq $Username})
   { 
     #If user does exist, output a warning message
     Write-Warning "A user account $Username has already exit in AD"
   }
   else 
   {
    #if a user does not exist then create a new user account
    #Account will be created in the OU listed in the $OU variable in the CSV file
    New-ADUser 
    -SamAccountName $Username
    -UserPrincipalName "$Username@server1.com"
    -Name "$FirstName $LastName"
    -GivenName $Firstname
    -SurName $Lastname
    -Enabled $true
    -ChangePasswordAtLogon $True 
    -DisplayName "$Lastname, $Firstname"
    -Department $Department
    -Path $OU
    -AccountPassword (covertto-securestring $Password =AsPlainText -Force)
    }
   }

