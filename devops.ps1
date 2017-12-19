<# Altering the time zone of the machine #>
#cd $env:WINDIR\system32\
#tzutil /s 'India Standard Time'

<# Import environment variables #>
$WebServerPort = $env:webserverport

Write-Host "Install IIS and other components"

<# Install IIS and enable the Dot Net 4.5 framework #>
Install-WindowsFeature -Name web-server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45

Write-Host "Enable web site port in the firewall"

<# Configure the IIS server #>
Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080
netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=8080

Write-Host "Install Chrome Browser"
<# Install Chocolatey  #>
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv

<# Install Google Chrome Browser #>
choco install googlechrome -y

Write-Host "Download Octopus"
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

Write-Host "Install Octopus"
<# Octopus Tentacle silent installation #>
cmd.exe /c msiexec /i $output /quiet

Write-Host "Install Octopus - Tentacle agent"
<# Octopus Tentacle temp path creation #>
$tempPath = "C:\Windows\system32\config\systemprofile\AppData\Local\Temp"
If(!(test-path $tempPath))
{
    New-Item -ItemType Directory -Force -Path $tempPath
}

<# Octopus Tentacle configuring Listening Tentacle in the machine #>
Set-Location -Path "C:\Program Files\Octopus Deploy\Tentacle"
cd "C:\Program Files\Octopus Deploy\Tentacle"

cmd /c Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config" --console
cmd /c Tentacle.exe new-certificate --instance "Tentacle" --if-blank --console
cmd /c Tentacle.exe configure --instance "Tentacle" --reset-trust --console
cmd /c Tentacle.exe configure --instance "Tentacle" --app "C:\Octopus\Applications" --port "10933" --noListen "False" --console
cmd /c Tentacle.exe configure --instance "Tentacle" --trust "9074FB0F78F1DFB3402445396C8CF2E0977BCEFB" --console
cmd /c netsh advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933
cmd /c Tentacle.exe service --instance "Tentacle" --install --stop --start --console

<# SQL command to update the DB #>
Write-Host "Update DB stuff"
Function ConnectionString([string] $ServerName, [string] $DbName, [string] $UserName, [string] $pwd)
{
    "Data Source=$ServerName;Initial Catalog=$DbName;User Id=$UserName;Password=$pwd;Integrated Security=False;Connect Timeout=120"
}

Function ReOpenConnection([System.Data.SqlClient.SqlConnection] $conn)
{
    switch ($conn.State)
    {
        "Open" { $conn.Close() } 
    }

    $conn.Open()
}

$masterConnStr = ConnectionString "fd-db01.southindia.cloudapp.azure.com" "InfraDB.Dev" "sa" "gavs_123"
$masterConn  = New-Object System.Data.SqlClient.SQLConnection($masterConnStr)

Write-Host "Connecting DB"
$mastercmd  = new-object System.Data.SQLClient.SQLCommand
$mastercmd.CommandText = "
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ENVIRONMENT_PROVISION]') AND type in (N'U'))
BEGIN
	UPDATE TBL_ENVIRONMENT_PROVISION SET IS_PROVISIONED = 1, ENV_COUNT = ENV_COUNT + 1
END"

$mastercmd.Connection = $masterConn
ReOpenConnection($masterConn)
$mastercmd.ExecuteNonQuery()
Write-Host "Update DB stuff - Completed"
$mastercmd.Dispose()
$masterConn.Close()
$masterConn.Dispose()
Write-Host "============================="
Write-Host " Script Execution Completed "
Write-Host "============================="
