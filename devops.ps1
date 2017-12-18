<# Altering the time zone of the machine #>
#cd $env:WINDIR\system32\
#tzutil /s 'India Standard Time'

<# Import environment variables #>
$WebServerPort = $env:webserverport

<# Install IIS and enable the Dot Net 4.5 framework #>
Install-WindowsFeature -Name web-server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45

<# Configure the IIS server #>
Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080
netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=8080

<# Install Chocolatey  #>
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv

<# Install Google Chrome Browser #>
choco install googlechrome -y

<# Download the Octopus Tentacle 64 bit agent to desktop location #>
$url = "https://download.octopusdeploy.com/octopus/Octopus.Tentacle.3.16.3-x64.msi"
$DownPath = "C:\temp"
If(!(test-path $DownPath))
{
    New-Item -ItemType Directory -Force -Path $DownPath
}
$output = "$DownPath\Octopus.Tentacle.3.16.3-x64.msi"
$start_time = Get-Date

$url
$output
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

<# Octopus Tentacle silent installation #>
cmd.exe /c msiexec /i $output /quiet

<# Octopus Tentacle configuring Listening Tentacle in the machine #>
Set-Location -Path "C:\Program Files\Octopus Deploy\Tentacle"
cd "C:\Program Files\Octopus Deploy\Tentacle"

cmd.exe /c Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config"
cmd.exe /c Tentacle.exe new-certificate --instance "Tentacle" --if-blank
cmd.exe /c Tentacle.exe configure --instance "Tentacle" --reset-trust
cmd.exe /c Tentacle.exe configure --instance "Tentacle" --app "C:\Octopus\Applications" --port "10933" --noListen "False"
cmd.exe /c Tentacle.exe configure --instance "Tentacle" --trust "9074FB0F78F1DFB3402445396C8CF2E0977BCEFB"
cmd.exe /c "netsh" advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933
cmd.exe /c Tentacle.exe service --instance "Tentacle" --install --stop --start


