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

Start-Process "c:\GCare\" GCareAgent.msi

#Start the msi installation
$msifile= "c:\GCare\gcare-agent\GCareAgent.msi"
    $arguments= ' /qn /l*v .\log.txt' 
   Start-Process `
     -file  $msifile `
     -arg $arguments `
     -passthru | wait-process

