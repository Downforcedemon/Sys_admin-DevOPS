[CmdletBinding()]
param (
    [Parameter(
      Mandatory = $true,
      HelpMessage = "Path to CSV file"
    )]
    [string] $Path = "",          #path to csv file

    [Parameter(
      Mandatory = $false,
      HelpMessage = "CSV file delimiter"
    )]
    [string] $Delimiter = ",",     # delimiter in csv file

    [Parameter(
      Mandatory = $false,
      HelpMessage = "Find users on DisplayName, Email or UserPrincipalName"
    )]
    #only take these values as input
    [ValidateSet("DisplayName", "Email", "UserPrincipalName")]       
    #validate the iput
    [string] $Filter = "DisplayName"
)

Function Add-UserToGroup {
    <#
    .SYNOPSIS
      Get users from the requested DN
    #>
    process{
      # Import the CSV File
      $users = Import-Csv -Path $path -Delimiter $delimiter

      # Find the users in the Active Directory
      $users | ForEach {
          $user = Get-ADUser -filter "$filter -eq '$($_.user)'" | Select ObjectGUID 

          if ($user) {
              Add-ADGroupMember -Identity $_.Group -Members $user
              Write-Host "$($_.user) added to $($_.Group)"
          }else {
              Write-Warning "$($_.user) not found in the Active Directory"
          }
      }
  }
}

# Load the Active Directory Module
Import-Module -Name ActiveDirectory

# Add user from CSV to given Group
Add-UserToGroup