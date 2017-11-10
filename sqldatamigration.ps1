
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

Write-Host "Create Source Table"
$cmd  = new-object System.Data.SQLClient.SQLCommand
$cmd.CommandText = "CREATE TABLE [dbo].[SourceDB1](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [date] NULL,
	[Email] [nvarchar](100) NULL,
	[Department] [nvarchar](100) NULL,
	[SSIN] [nvarchar](100) NULL,
	[AccountNumber] [nvarchar](100) NULL,
	[Address] [nvarchar](400) NULL,
	[DrivingLicence] [nvarchar](400) NULL
) ON [PRIMARY]"
$SrcConn.Open()
$cmd.Connection = $SrcConn
$cmd.ExecuteNonQuery()

$cmd.CommandText = "declare @sqlstmt nvarchar(1000)
set @sqlstmt ='begin
declare @iCnt int = 1
declare @iCntStr varchar(max)
	while (@iCnt <= 1000)
		begin
		set @iCntStr = cast( @iCnt as varchar(3))
		insert into SourceDB1 ([FirstName],[LastName],[DOB],[Email],[Department],[SSIN],[AccountNumber],[Address], [DrivingLicence] ) values (''FirstName'' + @iCntStr, ''LastName'' + @iCntStr , dateadd(MONTH, convert(int,100*rand()), ''1-Jan-1980'') , ''FirstName'' + @iCntStr + ''@gavstech.com'', ''Department'' + @iCntStr , ''100000000'' + @iCnt, ''1250000'' + @iCnt, ''Address, No: '' + @iCntStr , ''Drive000'' + @iCntStr )
		set  @iCnt = @iCnt +1
		end
end'

exec sp_executesql @sqlstmt"
$cmd.Connection = $SrcConn
$cmd.ExecuteNonQuery()
$SrcConn.Close()

$CmdText = "SELECT * FROM " + $SrcTable
$SqlCommand = New-Object system.Data.SqlClient.SqlCommand($CmdText, $SrcConn) 
$SrcConn.Open()
[System.Data.SqlClient.SqlDataReader] $SqlReader = $SqlCommand.ExecuteReader()
Write-Host "SRC connected"
Try
  {
    $DestConnStr = ConnectionString $DestServer $DestDatabase $DestUserName $DestPwd
    Write-Host "DEST connected"

    write-host "Create Target Table"
$cmd1  = new-object System.Data.SQLClient.SQLCommand
$cmd1.CommandText = "CREATE TABLE [dbo].[TargetDB](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Department] [nvarchar](100) NULL
) ON [PRIMARY]"
$tgtConn  = New-Object System.Data.SqlClient.SQLConnection($DestConnStr)
$tgtConn.Open()
$cmd1.Connection = $tgtConn
$cmd1.ExecuteNonQuery()

    $bulkCopy = New-Object Data.SqlClient.SqlBulkCopy($DestConnStr, [System.Data.SqlClient.SqlBulkCopyOptions]::KeepIdentity)
    $bulkCopy.DestinationTableName = $DestTable
    
    $bulkcopy.columnmappings.add("Id", "Id");
    $bulkcopy.columnmappings.add("FirstName", "FirstName");
    $bulkcopy.columnmappings.add("LastName", "LastName");
    $bulkcopy.columnmappings.add("Email", "Email");
    $bulkcopy.columnmappings.add("Department", "Department");
    $bulkcopy.batchsize = 100
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
