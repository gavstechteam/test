<# Installing additional Components: IIS – Internet Information Server and Tools with Management TooL,Google Chrome Latest,
 Mozilla Firefox Latest, Putty, 7-Zip,  G-Care Agent, Hyper-V,  DHCP, Java Runtime Latest, Tomcat, WebSphere, 
 SQL Server Management Studio 2017 (Client tool),MySQL Community Edition – latest, VC++ 2008 runtime libraries, VC++ 2010 runtime libraries,
 VC++ 2012 runtime libraries, VC++ 2013 runtime libraries,  VC++ 2015 runtime libraries, VC++ 2017 runtime libraries, Skype,
 Adobe Reader Latest, Notepad++ Latest, Dot Net 3.5 Framework, Dot Net 4.0 Framework, Dot Net 4.5 Framework, Dot Net 4.7 Framework,
 Visual Studio Code Latest, Dot Net Core Runtimes Latest, DirectX Latest, Microsoft Office Profession Plus 2013 #> 

<#Object Creation#>

$Windows_Application_List = [PSObject]@{
InstallIIS = "true"
InstallGooglechrome="true"
InstallMozillaFirefox = "true"
InstallPutty = "true"
Install7Zip = "true"
InstallTomcat = "true"
InstallMySQL = "true"
InstallJavaRE = "true"
Installvcredist2008 = "true"
Installvcredist2010 = "true"
Installvcredist2012 = "true"
Installvcredist2013 = "true"
Installvcredist2015 = "true"
Installvcredist2017 = "true"
InstallAdobe = "true"
InstallNotepadplusplus = "true"
InstallVSCode = "true"
InstallDotnetCoreRT = "true"
InstallDirectX = "true"
InstallDotnet3 = "true"
InstallDotnet4 = "true"
InstallDotnet4v5 = "true"
InstallDotnet4v7 = "true"
InstallMSProfPlus = "true"
InstallHyperV = "true"
InstallDHCP = "true"
InstallDNS = "true"
InstallADDS = "true"
InstallGCareAgent = "true"
InstallSQLServerManagementStudio = "true"
}

<#Chocolatey Package Installation for Windows#>
try {
<# Install Chocolatey  #>
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
refreshenv
}
catch
{
Write-Output "Unable to install the Chocolatey"
$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName
Write-Output $ErrorMessage
}

Start-Sleep -s 5

<#IIS with management tools#>
try{
if($Windows_Application_List.InstallIIS -eq "true")
{		
echo "Installing IIS"
# Install IIS Server #
Install-WindowsFeature -Name web-server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45

# Configure the IIS server #
Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:80:" -PropertyName Port -Value 8080
netsh advfirewall firewall add rule name="HTTP Web Application" dir=in action=allow protocol=TCP localport=8080
}
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}

Start-Sleep -s 10

<#Google Chrome Latest#>
try
{
if($Windows_Application_List.InstallGooglechrome -eq "true")
{
echo "Installing google chrome"
<# Google Chrome Browser #>
choco install googlechrome -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}


Start-Sleep -s 10

<#Mozilla Firefox latest#>
try
{
if($Windows_Application_List.InstallMozillaFirefox -eq "true")
{
echo "Installing Mozilla Firefox"
<# Mozilla Firefox latest#>
choco install firefox --version 58.0.2 -y
}         
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}

Start-Sleep -s 10

<#Putty#>
try
{
if($Windows_Application_List.InstallPutty -eq "true")
{
echo "Installing putty"
<# Putty application #>
choco install putty.install -y
}
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}

Start-Sleep -s 5

<#7-Zip#>
try {
If($Windows_Application_List.Install7Zip -eq "true")
{
echo "Installing 7-Zip"
<#7-Zip application#>
choco install 7zip.install -y
}
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage               
}

Start-Sleep -s 5

<#Tomcat Application#>
try {
echo "Installing  Tomcat" 
If($Windows_Application_List.InstallTomcat -eq "true")
{
<# Tomcat application #>
choco install tomcat -y
}
    }
catch 
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage      
}

Start-Sleep -s 10

<#MySQL Community Edition-latest#>
try {  
If($Windows_Application_List.InstallMySQL -eq "true")
{
echo "Installing MySQL"      
<# MySQL Installation #>
choco install mysql -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 		
}

Start-Sleep -s 10

<#Java SE Runtime Environment 8.0.161#>
try
{   
If($Windows_Application_List.InstallJavaRE -eq "true")
{
echo "Installing Java-SE"     
<# Java RE Install #>
choco install jre8 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage                
}

Start-Sleep -s 10

<#Microsoft Visual C++ 2008 Runtime libraries#>
try
{ 
If($Windows_Application_List.Installvcredist2008 -eq "true")
{
echo "Installing Visual C++ 2008"       
<# VC++ 2008 runtime libraries #>
choco install vcredist2008 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage  
}

Start-Sleep -s 5

<#Microsoft Visual C++ 2010 Runtime libraries#>
try
{ 
If($Windows_Application_List.Installvcredist2010 -eq "true")
{
echo "Installing Visual C++ 2010"       
<# VC++ 2010 runtime libraries #>
choco install vcredist2010 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage     
}

Start-Sleep -s 5

<#Microsoft Visual C++ 2012 Runtime libraries#>
try
{

If($Windows_Application_List.Installvcredist2012 -eq "true")
{
echo "Installing Visual C++ 2012"       
<# VC++ 2012 runtime libraries #>
choco install vcredist2012 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage  
}

Start-Sleep -s 5

<#Microsoft Visual C++ 2013 Runtime libraries#>
try
{
If($Windows_Application_List.Installvcredist2013 -eq "true")
{
echo "Installing Visual C++ 2013"       
<# VC++ 2013 runtime libraries #>
choco install vcredist2013 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 5

<#Microsoft Visual C++ 2015 Runtime libraries#>
try
{
If($Windows_Application_List.Installvcredist2015 -eq "true")
{
echo "Installing Visual C++ 2015"       
<# VC++ 2015 runtime libraries #>
choco install vcredist2015 -y
}
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage                
}

Start-Sleep -s 5

<#Microsoft Visual C++ 2017 Runtime libraries#>
try
{
If($Windows_Application_List.Installvcredist2017 -eq "true")
{
echo "Installing Visual C++ 2017"       
<# VC++ 2017 runtime libraries #>
choco install vcredist2017 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 5

<#Adobe Reader Latest#>
try
{
If($Windows_Application_List.InstallAdobe -eq "true")
{
echo "Installing Adobe Reader"    
<# Install Adobe Reader DC Update 18.011.20038#>
choco install adobereader-update
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 5

<#Notepad++ Application #>
try
{
If($Windows_Application_List.InstallNotepadplusplus -eq "true")
{
echo "Installing Notepadplusplus"    
<# Notepad++ 7.5.5#>
choco install notepadplusplus -y    
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 5

<#Visual Studio Code#>
try
{
If($Windows_Application_List.InstallVSCode -eq "true")
{
echo "Installing VSCode"    
<# Visual Studio Code 1.20.1 #>
choco install visualstudiocode -y                  
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 5

<#Dotnet Core Runtime latest#>
try
{
If($Windows_Application_List.InstallDotnetCoreRT -eq "true")
{
echo "Installing DotnetCoreRT"    
<# Microsoft .NET Core Runtime 2.1.0 #>
choco install dotnetcore-runtime --pre
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<#DirectX #>
try
{
If($Windows_Application_List.InstallDirectX -eq "true")
{
echo "Installing DirectX"    
<#DirectX 9.0.0.0 #>
choco install directx -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage    
}

Start-Sleep -s 10

<# Dot Net 3.5 Framework#>
try
{
If($Windows_Application_List.InstallDotnet3 -eq "true")
{
echo "Installing Dotnet3"    
<#Dot Net 3.5 3.5.20160716 #>
choco install dotnet3.5 -y
}
     }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<# Dot Net 4.0 Framework#>
try
{
If($Windows_Application_List.InstallDotnet4 -eq "true")
{
echo "Installing Dotnet 4.0 framework"    
<# Dot Net 4.0 Framework #>
choco install dotnet4.0 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<# Dot Net 4.5 Framework#>
try
{
If($Windows_Application_List.InstallDotnet4v5 -eq "true")
{
echo "Installing dotnet 4.5 framework" 
<# Dot Net 4.5 Framework #>
choco install dotnet4.5 -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<# Dot Net 4.7 Framework#>
try
{
If($Windows_Application_List.InstallDotnet4v7 -eq "true")
{
echo "Installing Dotnet 4.7 framework"   
<# Dot Net 4.7 Framework #>
choco install dotnet4.7 -y
}
  }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10


<#  Microsoft Office Profession Plus 2013 #>
try
{
If($Windows_Application_List.InstallMSProfPlus -eq "true")
{
echo "Installing MSProfPlus"    
<# Microsoft Office Professional Plus 2013 15.0.4827 #>
choco install officeproplus2013 -y
}
   }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<#Hyper-V#>
try
{
If($Windows_Application_List.InstallHyperV -eq "true")
{
echo "Installing Hyper-V"    
<# Installation of Hyper-V manager #>
Get-WindowsFeature Hyper-V
Install-WindowsFeature Hyper-V –Restart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Add-WindowsFeature RSAT-Hyper-V-Tools -IncludeAllSubFeature
}   
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<#DHCP- Server#>
try
{
If($Windows_Application_List.InstallDHCP -eq "true")
{
echo "Installing DHCP"    
<# Installation of DHCP-server #>
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Get-NetIPConfiguration
<#Scope for DHCP#>
Add-DhcpServerv4Scope -Name DHCPClient -Range 10.0.0.1\16  -SubnetMask 255.255.0.0
}      
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<#DNS #>
try
{
If($Windows_Application_List.InstallDNS -eq "true")
{
echo "Installing DNS"    
<#Installation of DNS- Server manager Application#>
Add-WindowsFeature -Name DNS -IncludeManagementTools
<#Get-Feature#>
Get-WindowsFeature -Name *DNS*
<#DNS-Primary Zone#>
Add-DnsServerPrimaryZone -Name zirrusgavs.com -zonefile zirrusgavs.com.DNS -DynamicUpdate NonsecureAndSecure
}          
    }
catch
{ 
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage 
}

Start-Sleep -s 10

<#Active Directory Domain-name Service#>
try
{
If($Windows_Application_List.InstallADDS -eq "true")
{
echo "Installing ADDS"    
<#Get list of modules#>
Get-Module -ListAvailable
                
<#Adding Active directory domain name service#>
Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
                 
<#Installation of ADDS-Forest#>
Install-ADDSForest -domainname zirrus.gavstech.com
}          
    }
catch
{ 
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage               
}

Start-Sleep -s 10

<#GCare-Agent Installation#>
try
{
echo "Installing GCare agent"
If($Windows_Application_List.InstallGCareAgent -eq "true")
{
<#Download and Install GCare Agent#> 
md "c:\gcare"
$out_file="c:\GCare\agentinstall.zip"
$dest_path="c:\GCare\"
$install_path= "c:\GCare\GCareAgent.msi"
$msi_filepath= "c:\GCare\gcare-agent\GCareAgent.msi"

#Download GCare Agent 
Invoke-WebRequest https://github.com/gavstechteam/test/raw/master/Gcare-Agent-msi.zip -OutFile $out_file

#Extract and copy the files in GCareagent
Expand-Archive $out_file -DestinationPath  $dest_path

#Start-Process $install_path -ArgumentList '/quiet' -Wait /log $dest_path+"\gcareinstall.log"

Start-Process "c:\GCare\" GCareAgent.msi

#Start the msi installation
$msifile= "c:\GCare\gcare-agent\GCareAgent.msi"
    $arguments= ' /qn /l*v .\log.txt' 
   Start-Process `
     -file  $msifile `
     -arg $arguments `
     -passthru | wait-process
}
      }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage               
}

Start-Sleep -s 10

<#SQL Server Management Studio#>
try {
If($Windows_Application_List.InstallSQLServerManagementStudio -eq "true")
{
echo "Installing SQL Server management studio"    
# SQL Server Management Studio #
choco install sql-server-management-studio -y
}
    }
catch
{
$ErrorMessage = $_.Exception.Message
echo $ErrorMessage
}
	 
