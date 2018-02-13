
<# Import environment variables #>
$WebServerPort = $env:webserverport

Write-Host "Install IIS and other components"

<# Install IIS and enable the Dot Net 4.5 framework #>
Install-WindowsFeature -Name web-server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45

Write-Host "Enable web site port in the firewall"

<# Configure the IIS server #>
Remove-WebSite -Name "Default Web Site"
<# Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080 #>
netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=8080

Write-Host "Install Chrome Browser"
<# Install Chocolatey  #>
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv


<# Install Google Chrome Browser #>
choco install googlechrome -y
