
<# Installing additional Components like
	Google Chrome browser, Putty utilities
	in Azure windows based vm images #>


 <# Import environment variables #>

 Param(
  [string]$InstallGooglechrome,
  [string]$InstallPutty
)

   
  

  $InstallGooglechrome | out-file "C:\output.txt"
  $InstallPutty | Add-Content "C:\output.txt"

<#TimeZone Alteration#>
	try {
	# Altering the time zone of the machine #
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

	

	