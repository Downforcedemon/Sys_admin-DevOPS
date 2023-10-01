# Define the Active Directory group names
$groupNames = @("testgroup", "testgroup1")

# Define a list of users with their first names and last names
$users = @(
    @{
        FirstName = "test"
        LastName = "user"
        }
    
    # Add more users as needed
)

# Iterate through each user and remove them from the groups
foreach ($user in $users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName

    # Search Active Directory for the user's SAM account name based on first and last names
    $userAD = Get-ADUser -Filter {GivenName -eq $firstName -and Surname -eq $lastName}

    if ($userAD) {
        $samAccountName = $userAD.SamAccountName

        try {
            # Remove the user from the groups
            foreach ($groupName in $groupNames) {
                Remove-ADGroupMember -Identity $groupName -Members $samAccountName -Confirm:$false
                Write-Host "Removed $samAccountName from $groupName"
            }
        } catch {
            $errorMessage = "Failed to remove $samAccountName from groups"
            Write-Host $errorMessage
        }
    } else {
        Write-Host "User with first name $firstName and last name $lastName not found in Active Directory."
    }
}
