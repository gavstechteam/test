<# Altering the time zone of the machine #>
cd $env:WINDIR\system32\
tzutil /s 'India Standard Time'
 
<# Install Chocolatey  #>
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv
 
<# VC++ runtimes needed as dependencies for other installations #>
choco install vcredist-all -y
 
<# SQL Server Management Studio #>
choco install sql-server-management-studio -y
		
<# Install IIS Server #>
Install-WindowsFeature -Name web-server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45
 
<# Configure the IIS server #>
Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080
netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=8080
 
 
#If($InstallIIS -eq 'true')
#{
    <# Install the IIS server #>
    Install-WindowsFeature -Name web-server -IncludeManagementTools
    Install-WindowsFeature -Name Web-Asp-Net45
 
    <# Configure the Firewall #>
    #Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value $WebServerPort
    #netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=$WebServerPort
 
    If($WebServerPackage -ne '')
    {
        # Folders
#        New-Item -ItemType Directory c:\temp
#        New-Item -ItemType Directory c:\sites
 
        # Download app package
#        Invoke-WebRequest  $WebServerPackage -OutFile c:\temp\app.zip
#        Expand-Archive C:\temp\app.zip c:\sites
 
        # Configure iis
#        Remove-WebSite -Name "Default Web Site"
        #Set-ItemProperty IIS:\AppPools\DefaultAppPool\ managedRuntimeVersion ""
#        New-Website -Name "Application" -Port 80 -PhysicalPath C:\sites\ -ApplicationPool DefaultAppPool & iisreset
    }
#}
 
 
#<# Import environment variables #>
# $InstallIIS = $env:installiis
# $InstallTomcat = $env:installtomcat
# $InstallWebSphere = $env:installwebsphere
# $InstallMySQL = $env:installmysql
# $InstallGooglechrome = $env:installgooglechrome
# $InstallPutty = $env:installputty
# $Install7Zip = $env:install7zip
# $WebServerPort = $env:webserverport
# $WebServerPackage = $env:webserverpackage
# $InstallSplunk = $env:installsplunk
# $SplunkFwdIP =  $env:splunkfwdip
 
 
choco feature enable -n allowGlobalConfirmation
 
#If($InstallGooglechrome -eq 'true')
#{
	<# Google Chrome Browser #>
	choco install googlechrome -y
#}
 
#If($InstallPutty -eq 'true')
#{
	<# Putty application #>
	choco install putty.install -y
#}
 
#If($InstallMySQL -eq 'true')
#{
	<# 7zip application #>
	choco install 7zip -y
 
	<# MySQL #>
	choco install mysql -y
#}
 
 

 
