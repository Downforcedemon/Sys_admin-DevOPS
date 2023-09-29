# Define the Active Directory group names
$groupNames = @("lease info_adhoc", "lease info_mim")

# Define the list of team members to remove from the groups
$teamMembers = @(
    "user1",
    "user2",
    "user3"
    # Add more usernames as needed
)

# Iterate through each group and remove team members
foreach ($groupName in $groupNames) {
    foreach ($member in $teamMembers) {
        try {
            # Remove the user from the group
            Remove-ADGroupMember -Identity $groupName -Members $member -Confirm:$false
            Write-Host "Removed $member from $groupName"
        } catch {
            $errorMessage = "Failed to remove $member from $groupName: " + $_.Exception.Message
            Write-Host $errorMessage
        }
    }
}
