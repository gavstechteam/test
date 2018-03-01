<# Custom Powershell Application software installation scripts used for Azure - Windows based machines. 
   This script is used by one of the ZIF application software to spin up new machine with pre-configured
   application softwares in it.
#>

<# Installing additional Components: IIS – Internet Information Server and Tools with Management TooL,Google Chrome Latest,
 Mozilla Firefox Latest, Putty, 7-Zip,  G-Care Agent, Hyper-V,  DHCP, Java Runtime Latest, Tomcat, WebSphere, 
 SQL Server Management Studio 2017 (Client tool),MySQL Community Edition – latest, VC++ 2008 runtime libraries, VC++ 2010 runtime libraries,
 VC++ 2012 runtime libraries, VC++ 2013 runtime libraries,  VC++ 2015 runtime libraries, VC++ 2017 runtime libraries, Skype,
 Adobe Reader Latest, Notepad++ Latest, Dot Net 3.5 Framework, Dot Net 4.0 Framework, Dot Net 4.5 Framework, Dot Net 4.7 Framework,
 Visual Studio Code Latest, Dot Net Core SDK Latest, DirectX Latest, Microsoft Office Profession Plus 2013 #> 

<# Parameters for the current File #>
Param(
  [string]$InstallIIS,
  [string]$InstallGooglechrome,
  [string]$InstallMozillaFirefox,
  [string]$InstallPutty,
  [string]$Install7Zip,
  [string]$InstallTomcat,
  [string]$InstallMySQL,
  [string]$InstallJavaRE,
  [string]$Installvcredist2008,
  [string]$Installvcredist2010,
  [string]$Installvcredist2012,
  [string]$Installvcredist2013,
  [string]$Installvcredist2015,
  [string]$Installvcredist2017,
  [string]$InstallAdobe,
  [string]$InstallNotepadplusplus,
  [string]$InstallVSCode,
  [string]$InstallDotnetCoreRT,
  [string]$InstallDirectX,
  [string]$InstallDotnet3,
  [string]$InstallDotnet4,
  [string]$InstallDotnet4v5,
  [string]$InstallDotnet4v7,
  [string]$InstallMSProfPlus,
  [string]$InstallHyperV,
  [string]$InstallDHCP,
  [string]$InstallDNS,
  [string]$InstallADDS,
  [string]$InstallGCareAgent,
  [string]$InstallSQLServerManagementStudio  
)

<#TimeZone Alteration#>
<#
try {
		cd $env:WINDIR\system32\
		tzutil /s 'India Standard Time'
	}
catch
	{
		Write-Output "Unable to set the time zone"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}
#>


<#Chocolatey Package Install for Windows#>
try {
		<# Install Chocolatey  #>
		iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
		refreshenv

        choco feature enable -n allowGlobalConfirmation
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
try {

       If($InstallIIS -eq "true")
{
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
		Write-Output "Unable to install IIS Server"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#Google Chrome Latest#>
try {
		if($InstallGooglechrome -eq "true")
		{
			<# Google Chrome Browser #>
			choco install googlechrome -y
		}
	}
catch
	{
		Write-Output "Unable to install Google Chrome browser"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#Mozilla Firefox latest#>
try
    {
        If($InstallMozillaFirefox -eq "true")
        {
            <# Mozilla Firefox latest#>
            choco install firefox --version 58.0.2 -y
         }          
    }
catch
    {
        Write-Output "Unable to install Firefox application"
	    $ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName
	    Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#Putty#>
try {
	    If($InstallPutty -eq "true")
	    {
		    <# Putty application #>
		    choco install putty.install -y
        }            
    }

catch
	{
		Write-Output "Unable to install Putty application"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#7-Zip#>
try {
    If($Install7Zip -eq "true")
    {
        <#7-Zip application#>
        choco install 7zip.install -y
    }
}
catch
    {
        Write-Output "Unable to install 7-zip application"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#Tomcat Application#>
try {
        If($InstallTomcat -eq "true")
        {
            <# Tomcat application #>
            choco install tomcat -y
        }

    }
catch 
    {
	    Write-Output "Unable to install tomcat"
	    $ErrorMessage = $_.Exception.Message
	    $FailedItem = $_.Exception.ItemName
	    Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#MySQL Community Edition-latest#>
try {
		If($InstallMySQL -eq "true")
		{
			<# MySQL Installation #>
			choco install mysql -y
		}
	}
catch
	{
		Write-Output "Unable to install MySQL server"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}

Start-Sleep -s 5

<#Java SE and Runtime Environment 8.0.161#>
try
    {
        If($InstallJavaRE -eq "true")
        {
            <# Java RE Install #>
            choco install jre8 -y
        }
    }
catch
    {
        Write-Output "JRE is not installed"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Microsoft Visual C++ 2008 Runtime libraries#>
try
    {
        If($Installvcredist2008 -eq "true")
        {
            <# VC++ 2008 runtime libraries #>
            choco install vcredist2008 -y
        }
    }

catch
    {
        Write-Output "Unable to install VC++ 2008 runtime libraries"
        $ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Microsoft Visual C++ 2010 Runtime libraries#>
try
    {
        If($Installvcredist2010 -eq "true")
        {
            <# VC++ 2010 runtime libraries #>
            choco install vcredist2010 -y
        }
    }
catch
    {
        Write-Output "Unable to install VC++ 2010 runtime libraries"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Microsoft Visual C++ 2012 Runtime libraries#>
try
    {
        If($Installvcredist2012 -eq "true")
        {
            <# VC++ 2012 runtime libraries #>
            choco install vcredist2012 -y
        }
    }
catch
    {
        Write-Output "Unable to install VC++ 2012 runtime libraries"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Microsoft Visual C++ 2013 Runtime libraries#>
try
    {
        If($Installvcredist2013 -eq "true")
        {
            <# VC++ 2013 runtime libraries #>
            choco install vcredist2013 -y
        }
    }
catch
    {
        Write-Output "Unable to install VC++ 2013 runtime libraries"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5
                
<#Microsoft Visual C++ 2015 Runtime libraries#>
try
    {
        If($Installvcredist2015 -eq "true")
        {
            <# VC++ 2015 runtime libraries #>
            choco install vcredist2015 -y
        }
    }
catch
    {
        Write-Output "Unable to install VC++ 2015 runtime libraries"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Microsoft Visual C++ 2017 Runtime libraries#>
try
    {
        If($Installvcredist2017 -eq "true")
        {
            <# VC++ 2017 runtime libraries #>
            choco install vcredist2017 -y
        }
    }
catch
    {
        Write-Output "Unable to install VC++ 2017 runtime libraries"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Adobe Acrobat Reader Latest#>
try
{
    If($InstallAdobe -eq "true")
        {
            <# Install Adobe Reader DC Update 18.011.20038#>
            choco install adobereader-update
        }
    }
catch
    {
        Write-Output "Unable  to install Adobe Acrobat Reader "
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Notepad++ Application #>
try
    {
        If($InstallNotepadplusplus -eq "true")
        {
            <# Notepad++ 7.5.5#>
            choco install notepadplusplus -y    
        }
    }
catch
    {
        Write-Output "Unable  to install Notepad++ "
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Visual Studio Code#>
try
    {
        If($InstallVSCode -eq "true")
        {
            <# Visual Studio Code 1.20.1 #>
            choco install visualstudiocode -y
        }
    }
catch
    {
        Write-Output "Unable to install Visual Studio Code"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Dotnet Core SDK latest#>
try
    {
        If($InstallDotnetCoreRT -eq "true")
        {
            <# Microsoft .NET Core Latest sdk #>
            choco install dotnetcore-sdk -y
        }
    }
catch
    {
        Write-Output "Unable to install Dotnet Core Runtime"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#DirectX #>
try
    {
        If($InstallDirectX -eq "true")
        {
            <#DirectX 9.0.0.0 #>
            choco install directx -y
        }
    }
catch
    {
        Write-Output "Unable to install DirectX"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<# Dot Net 3.5 Framework#>
try
    {
        If($InstallDotnet3 -eq "true")
        {
            <#Dot Net 3.5 3.5.20160716 #>
            choco install dotnet3.5 -y
        }
    }
catch
    {
        Write-Output "Unable to install Dotnet 3.5 Framework"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<# Dot Net 4.0 Framework#>
try
    {
        If($InstallDotnet4 -eq "true")
        {
            <# Dot Net 4.0 Framework #>
            choco install dotnet4.0 -y
        }
    }
catch
    {
        Write-Output "Unable to install Dotnet 4.0 Framework"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<# Dot Net 4.5 Framework#>
try
    {
        If($InstallDotnet4v5 -eq "true")
        {
            <# Dot Net 4.5 Framework #>
            choco install dotnet4.5 -y
        }
    }
catch
    {
        Write-Output "Unable to install Dotnet 4.5 Framework"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<# Dot Net 4.7 Framework#>
try
    {
        If($InstallDotnet4v7 -eq "true")
        {
            <# Dot Net 4.7 Framework #>
            choco install dotnet4.7 -y
        }
    }
catch
    {
        Write-Output "Unable to install Dotnet 4.7 Framework"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#  Microsoft Office Profession Plus 2013 #>
try
    {
        If($InstallMSProfPlus -eq "true")
        {
            <# Microsoft Office Professional Plus 2013 15.0.4827 #>
            choco install officeproplus2013 -y
        }
    }
catch
    {
        Write-Output "Unable to install Microsoft Office Professional Plus 2013"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Hyper-V#>
try
    {
        If($InstallHyperV -eq "true")
        {
            <# Installation of Hyper-V manager #>
            Get-WindowsFeature Hyper-V*
            Install-WindowsFeature RSAT-Hyper-V-Tools
        }   
    }
catch
    {
        Write-Output "Unable to install Hyper-V manager"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5


<#DHCP- Server#>
try
    {
        If($InstallDHCP -eq "true")
        {
            <# Installation of DHCP-server #>
            Install-WindowsFeature -Name DHCP -IncludeManagementTools
            Get-NetIPConfiguration
            <#Scope for DHCP#>
            Add-DhcpServerv4Scope -Name DHCPClient -StartRange 10.0.0.1 -EndRange 10.0.15.254 -SubnetMask 255.255.240.0
        }      
    }
catch
    {
        Write-Output "Unable to install DHCP"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#DNS #>
try
    {
        If($InstallDNS -eq "true")
        {
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
        Write-Output "Unable to install DNS"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#Active Directory Domain-name Service#>
try
    {
        If($InstallADDS -eq "true")
        {
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
        Write-Output "Unable to install ADDS"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#GCare Agent Installation#>
try
    {
        If($InstallGCareAgent -eq "true")
        {
            <#Download and Install GCare Agent#> 
            md "c:\gcare"
            $out_file="c:\GCare\agentinstall.zip"
            $dest_path="c:\GCare\"
            $install_path= "c:\GCare\GCareAgent.msi"
            $msi_filepath= "c:\GCare\gcare-agent\GCareAgent.msi"

            #Download GCare Agent 
            Invoke-WebRequest https://github.com/Madhubala-E/AzureIIS-webserver/raw/master/gcare-agent.zip -OutFile $out_file

            #Extract and copy the files in GCareagent
            Expand-Archive $out_file -DestinationPath  $dest_path

            #Start-Process $install_path -ArgumentList '/quiet' -Wait /log $dest_path+"\gcareinstall.log"

            #Start-Process "c:\GCare\" GCareAgent.msi

            #Start the msi installation
            $msifile= "c:\GCare\gcare-agent\GCareAgent.msi"
            $arguments= ' /qn /l*v .\gcareinstall.log' 
            Start-Process `
                -file  $msifile `
                -arg $arguments `
                -passthru | wait-process
        }
    }
catch
    {
        Write-Output "Unable to install Gcare Agent"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
    }

Start-Sleep -s 5

<#SQL Server Management Studio#>
try 
    {
        If($InstallSQLServerManagementStudio -eq "true")
        {
            # SQL Server Management Studio #
            choco install sql-server-management-studio -y
        }
    }
catch
	{
		Write-Output "Unable to install SQL Server management Studio"
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		Write-Output $ErrorMessage
	}      




 