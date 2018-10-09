$Windows_Application_List = [PSObject]@{
InstallXPSViewer = "true"
InstallTelnetClient = "true"
}
Write-Output "Execution Started"

Write-Output "app 1 Started"

<#XPS Viewer#>
try
{
if($Windows_Application_List.InstallXPSViewer -eq "true")
{
echo "Installing XPSViewer"
Install-WindowsFeature -Name “XPS-Viewer” -y
}         
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}

Write-Output "app 1 installation completed"

Write-Output "app 2 Started"

<#Telnet-Client#>
try
{
if($Windows_Application_List.InstallTelnetClient -eq "true")
{
echo "Installing TelnetClient"
Install-WindowsFeature -name Telnet-Client -y
}         
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}

Write-Output "app 2 installation completed"
