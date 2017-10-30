<# Import environment variables #>
 $InstallIIS = $env:installiis
 $InstallTomcat = $env:installtomcat
 $InstallWebSphere = $env:installwebsphere
 $InstallMySQL = $env:installmysql
 $InstallGooglechrome = $env:installgooglechrome
 $InstallPutty = $env:installputty
 $Install7Zip = $env:install7zip
 $WebServerPort = $env:webserverport
 $WebServerPackage = $env:webserverpackage
 $InstallSplunk = $env:installsplunk
 $SplunkFwdIP =  $env:splunkfwdip


choco feature enable -n allowGlobalConfirmation

If($InstallGooglechrome -eq 'true')
{
	<# Google Chrome Browser #>
	choco install googlechrome -y
}

If($InstallPutty -eq 'true')
{
	<# Putty application #>
	choco install putty.install -y
}

If($InstallMySQL -eq 'true')
{
	<# 7zip application #>
	choco install 7zip -y

	<# MySQL #>
	choco install mysql -y
}
