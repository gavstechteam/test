
Param 
(
      [parameter(Mandatory = $false)]
      [string] $SrcServer = "ZIRRUSWEBSVR",

      [parameter(Mandatory = $false)]
      [string] $SrcDatabase = "zirrus",

      [parameter(Mandatory = $false)]
      [string] $SrcTable = "sourcedb",

      [parameter(Mandatory = $false)]
      [string] $SrcUserName = "zirrusdev",

      [parameter(Mandatory = $false)]
      [string] $SrcPwd = "Z!rrus99",

      [parameter(Mandatory = $false)]
      [string] $DestServer = "ZIRRUSWEBSVR",

      # Name of the destination database is optional. When omitted, it is set to the source database name.
      [parameter(Mandatory = $false)]
      [string] $DestDatabase = "zirrustest", 

      # Name of the destination table is optional. When omitted, it is set to the source table name.
      [parameter(Mandatory = $false)]
      [string] $DestTable = "targetdb", 

      [parameter(Mandatory = $false)]
      [string] $DestUserName = "zirrustest",

      [parameter(Mandatory = $false)]
      [string] $DestPwd = "Z!rrus99",

      [switch] $Truncate = $false # Include this switch to truncate the destination table before the copy.
  )
 
 If ($DestDatabase.Length –eq 0) 
 {
    $DestDatabase = $SrcDatabase
 }


 If ($DestTable.Length –eq 0) 
 {
    $DestTable = $SrcTable
 }

 
 If ($Truncate) 
 {
    $TruncateSql = "TRUNCATE TABLE " + $DestTable
    Sqlcmd -S $DestServer -d $DestDatabase -Q $TruncateSql
 }

Function ConnectionString([string] $ServerName, [string] $DbName, [string] $UserName, [string] $pwd)
{
    "Data Source=$ServerName;Initial Catalog=$DbName;User Id=$UserName;Password=$pwd;Integrated Security=False;"
}

Write-Host "Started" 
$SrcConnStr = ConnectionString $SrcServer $SrcDatabase $SrcUserName $SrcPwd
$SrcConn  = New-Object System.Data.SqlClient.SQLConnection($SrcConnStr)
$CmdText = "SELECT * FROM " + $SrcTable
$SqlCommand = New-Object system.Data.SqlClient.SqlCommand($CmdText, $SrcConn) 
$SrcConn.Open()
[System.Data.SqlClient.SqlDataReader] $SqlReader = $SqlCommand.ExecuteReader()
Write-Host "SRC connected"
Try
  {
    $DestConnStr = ConnectionString $DestServer $DestDatabase $DestUserName $DestPwd
    Write-Host "DEST connected"

    $bulkCopy = New-Object Data.SqlClient.SqlBulkCopy($DestConnStr, [System.Data.SqlClient.SqlBulkCopyOptions]::KeepIdentity)
    $bulkCopy.DestinationTableName = $DestTable
    
    $bulkcopy.columnmappings.add("id", "id");
    $bulkcopy.columnmappings.add("firstname", "firstname");
    $bulkcopy.columnmappings.add("lastname", "lastname");
    $bulkcopy.columnmappings.add("email", "email");
    $bulkcopy.columnmappings.add("department", "department");
    $bulkcopy.columnmappings.add("address", "address");
    $bulkcopy.batchsize = 10
    $bulkcopy.bulkcopytimeout = 120

    Write-Host "Copying Started"
    $bulkCopy.WriteToServer($sqlReader)
   
    Write-Host "Table $SrcTable in $SrcDatabase database on $SrcServer has been copied to table $DestTable in $DestDatabase database on $DestServer"
    Write-Host "Completed"
  }
  Catch [System.Exception]
  {
    $ex = $_.Exception
    Write-Host $ex.Message
  }
  Finally
  {
    $SqlReader.close()
    $SrcConn.Close()
    $SrcConn.Dispose()
    $bulkCopy.Close()
  }
