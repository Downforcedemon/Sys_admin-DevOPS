configuration InstalledRoles
{
    Param([String[]]$ComputerName = "srv01")                      # param([String]) is uses to call on variable 
    Import-DscResource -ModuleName PSDesiredStateconfiguration    # 
    Node $ComputerName
    {
        WindowsFeature HaveBitLocker
        {
            Ensure = "Present"
            Name = "BitLocker"
            {
                Ensure = "Absent"
                Name = "Web-Server"
            }
        }
    }
}