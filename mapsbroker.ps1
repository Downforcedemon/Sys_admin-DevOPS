# create a class/function and assign a name which is stopmaps
Configuration StopMaps           
{
    Import-DscResource -Module PSDesiredStateconfiguration           #import DsC
    Node localhost                                                   #specify which node to manage
    {
        service Disablmaps                                            #define what to do with node by calling resource "service" and call it a name
        {
            Name = "MapsBroker"                                        #config data tha "service" will use
            StartupType = "Disabled"                           
            State = "Stopped"
        }
    }
}