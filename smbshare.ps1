#use smb pull server to update computers for configs
#change folder to DSC(not installed on linux yet)
Install-Module xSmBShare  
Install -Module cNtfsAccessControl

Configuration SMBPull    # create a block that defines rosources that will manage the desired state
{
    Import-DscResource -Modulename PSDesiredStateconfiguration    #import the required DSC resources
    Import-DscResource -Modulename xSmBShare
    Import-DscResource -Modulename cNtfsAccessControl

    Node localhost       # specify the target node. #localhost can be desktop name QQ: differnt hosts
    {
        File CreateFolder        #check if we have a folder to share, otherwise create it
        {
            Destinationpath = 'C:\DSCSMB'
            Type = 'Directory'
            Ensure = 'Present'
        }
        #creare a share on the target node
        xSmBShare CreateShare
        {
            Name = 'DscSmbPull'
            Path = 'C:\DSCSMB'
            FullAccess = 'username/administrator'
            ReadAcess = '$'
            FolderEnuerationMode = 'AccessBased'
            DependsOn = '[File]CreateFolder'
        }
        #create ntfs permissions
        cNtfsPermissionEntry PermissionSet1
        {
            Ensure = 'Present'
            path = 'C:\DSCSMB'
            Principal = 'landonhote/srv02$'          #assigning permissions srv02$ computer, rwx
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'thisFolderSubfoldersAndfiles'
                    NoPropogateInherit = $false
                }
            )
        }
        }
        }
    }
}

# local host settings
# config local config manager (LCM accepts DSC config and applies)
[DSCLocalConfigurationManager()]
Configuration PullClientConfigID
{
    Node localhost
    {
        settings                   #how the LCM will operate
        {
            RefreshMode = 'Pull'
            ConfigurationID = '#paste GID here'
            Refresh FrequencyMins = 30
            RebootNOdeIfNeeded = $true  #change it false
             # Configurationmode = 'Applyand monitor' --or-- 'applyautocorrect'
           
        }
        ConfigurationRepositoryshare SMBPullServer
        {
            SourcePath = '\\srv01\DSCSmbpull'
        }
    }
}