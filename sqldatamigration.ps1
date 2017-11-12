
Param 
(
      [parameter(Mandatory = $false)]
      [string] $SrcServer = "(local)",

      [parameter(Mandatory = $false)]
      [string] $SrcDatabase = "sourceDB",

      [parameter(Mandatory = $false)]
      [string] $SrcTable = "sourceTbl",

      [parameter(Mandatory = $false)]
      [string] $SrcUserName = "srcuser",

      [parameter(Mandatory = $false)]
      [string] $SrcPwd = "Zirrus@123",

      [parameter(Mandatory = $false)]
      [string] $DestServer = "(local)",

      # Name of the destination database is optional. When omitted, it is set to the source database name.
      [parameter(Mandatory = $false)]
      [string] $DestDatabase = "DestDB", 

      # Name of the destination table is optional. When omitted, it is set to the source table name.
      [parameter(Mandatory = $false)]
      [string] $DestTable = "targetTbl", 

      [parameter(Mandatory = $false)]
      [string] $DestUserName = "destuser",

      [parameter(Mandatory = $false)]
      [string] $DestPwd = "Zirrus@123",

      [switch] $Truncate = $false # Include this switch to truncate the destination table before the copy.
  )

  
# If ($DestDatabase.Length –eq 0) 
# {
#    $DestDatabase = $SrcDatabase
# }


# If ($DestTable.Length –eq 0) 
# {
#    $DestTable = $SrcTable
# }
 


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

Try
  {

Write-Host "Enabing Mixed mode authentication"

$rootConnStr = "Data Source=(local);Initial Catalog=master;Integrated Security=true;Connect Timeout=120"
$rootConn  = New-Object System.Data.SqlClient.SQLConnection($rootConnStr)
$rootcmd  = new-object System.Data.SQLClient.SQLCommand

$rootcmd.CommandText = "USE MASTER;
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2

ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = 'gavs_123' ;
"

$rootConn.Open()
$rootcmd.Connection = $rootConn
$rootcmd.ExecuteNonQuery()
$rootConn.Close()
$rootcmd.Dispose()

Restart-Service -Force MSSQLSERVER

Write-Host "Enabing Mixed mode authentication - Completed"

$masterConnStr = ConnectionString "(local)" "master" "sa" "gavs_123"
$masterConn  = New-Object System.Data.SqlClient.SQLConnection($masterConnStr)


Write-Host "Creating Source DB"

$mastercmd  = new-object System.Data.SQLClient.SQLCommand
$mastercmd.CommandText = "USE MASTER;
IF NOT EXISTS ( SELECT  name
            FROM    sys.databases
            WHERE   name = N'" + $SrcDatabase + "' )
CREATE DATABASE " + $SrcDatabase + ";"

$mastercmd.Connection = $masterConn
ReOpenConnection($masterConn)
$mastercmd.ExecuteNonQuery()
Write-Host "Creating Source DB - Completed"

Write-Host "Creating Destination DB"
$mastercmd.CommandText = "USE MASTER;
IF NOT EXISTS ( SELECT  name
            FROM    sys.databases
            WHERE   name = N'" + $DestDatabase + "' )
    CREATE DATABASE " + $DestDatabase + ";"

ReOpenConnection($masterConn)
$mastercmd.Connection = $masterConn
$mastercmd.ExecuteNonQuery()
Write-Host "Creating Destination DB - Completed"

Write-Host "Creating Logins"
$cmdLogin  = new-object System.Data.SQLClient.SQLCommand
$cmdLogin.CommandText = "USE [master]
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'" + $SrcUserName + "')
    DROP LOGIN [" + $SrcUserName + "]

CREATE LOGIN [" + $SrcUserName + "] WITH PASSWORD=N'" + $SrcPwd + "', DEFAULT_DATABASE=[" + $SrcDatabase + "], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

USE [" + $SrcDatabase + "]
CREATE USER [" + $SrcUserName + "] FOR LOGIN [" + $SrcUserName + "]
ALTER USER [" + $SrcUserName + "] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_owner] ADD MEMBER [" + $SrcUserName + "]
"
ReOpenConnection($masterConn)
$cmdLogin.Connection = $masterConn
$cmdLogin.ExecuteNonQuery()

$cmdLogin.CommandText = "USE [master]
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'" + $DestUserName + "')
    DROP LOGIN [" + $DestUserName + "]

CREATE LOGIN [" + $DestUserName + "] WITH PASSWORD=N'" + $DestPwd + "', DEFAULT_DATABASE=[" + $DestDatabase + "], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

USE [" + $DestDatabase + "]
CREATE USER [" + $DestUserName + "] FOR LOGIN [" + $DestUserName + "]
ALTER USER [" + $DestUserName + "] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_owner] ADD MEMBER [" + $DestUserName + "]
"
ReOpenConnection($masterConn)
$cmdLogin.Connection = $masterConn
$cmdLogin.ExecuteNonQuery()

Write-Host "Creating Logins - Completed"

 
If ($Truncate) 
{
    $TruncateSql = "TRUNCATE TABLE " + $DestTable
    Sqlcmd -S $DestServer -d $DestDatabase -Q $TruncateSql
}

$SrcConnStr = ConnectionString $SrcServer $SrcDatabase $SrcUserName $SrcPwd
$SrcConn  = New-Object System.Data.SqlClient.SQLConnection($SrcConnStr)

Write-Host "Create Source Table"
$cmd  = new-object System.Data.SQLClient.SQLCommand
$cmd.CommandText = "SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[" + $SrcTable + "]') AND type in (N'U'))
BEGIN

    CREATE TABLE [dbo].[" + $SrcTable + "](
	    [Id] [int] IDENTITY(1,1) NOT NULL,
	    [FirstName] [nvarchar](100) NULL,
	    [LastName] [nvarchar](100) NULL,
	    [DOB] [date] NULL,
	    [Email] [nvarchar](100) NULL,
	    [Department] [nvarchar](100) NULL,
	    [SSIN] [nvarchar](100) NULL,
	    [AccountNumber] [nvarchar](100) NULL,
	    [Address] [nvarchar](400) NULL,
	    [DrivingLicence] [nvarchar](400) NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
        [ModifiedDate] [datetime] NOT NULL DEFAULT (getdate())
    ) ON [PRIMARY] 
END

declare @sqlstmt nvarchar(1000)
set @sqlstmt ='begin
declare @iCnt int = 1
declare @iCntStr varchar(max)
	while (@iCnt <= 10000)
		begin
		set @iCntStr = cast( @iCnt as varchar(9))
		insert into " + $SrcTable + " ([FirstName],[LastName],[DOB],[Email],[Department],[SSIN],[AccountNumber],[Address], [DrivingLicence], [CreatedDate] ) values (''FirstName'' + @iCntStr, ''LastName'' + @iCntStr , dateadd(MONTH, convert(int,100*rand()), ''1-Jan-1980'') , ''FirstName'' + @iCntStr + ''@gavstech.com'', ''Department'' + cast(convert(int,10*rand()+1) as varchar(10)) , ''100000000'' + @iCnt, ''1250000'' + @iCnt, ''Address, No: '' + @iCntStr , ''Drive000'' + @iCntStr, dateadd(day, -convert(int,10*rand()), getdate()) )
		set  @iCnt = @iCnt +1
	end
end'

exec sp_executesql @sqlstmt"
ReOpenConnection($SrcConn)
$cmd.CommandTimeout = 600
$cmd.Connection = $SrcConn
$cmd.ExecuteNonQuery()


$CmdText = "SELECT * FROM " + $SrcTable
$SqlCommand = New-Object system.Data.SqlClient.SqlCommand($CmdText, $SrcConn) 
ReOpenConnection($SrcConn)
[System.Data.SqlClient.SqlDataReader] $SqlReader = $SqlCommand.ExecuteReader()
Write-Host "Source Table connected"

    $DestConnStr = ConnectionString $DestServer $DestDatabase $DestUserName $DestPwd
    Write-Host "Destination DB connected"

    write-host "Create Target Table"
    $cmd1  = new-object System.Data.SQLClient.SQLCommand
    $cmd1.CommandText = "SET ANSI_NULLS ON
    SET QUOTED_IDENTIFIER ON

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[" + $DestTable + "]') AND type in (N'U'))
    BEGIN
        CREATE TABLE [dbo].[" + $DestTable + "](
	        [Id] [int] IDENTITY(1,1) NOT NULL,
	        [FirstName] [nvarchar](100) NULL,
	        [LastName] [nvarchar](100) NULL,
	        [Email] [nvarchar](100) NULL,
	        [Department] [nvarchar](100) NULL,
            [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
            [ModifiedDate] [datetime] NOT NULL DEFAULT (getdate())
        ) ON [PRIMARY]
    END"

    $tgtConn  = New-Object System.Data.SqlClient.SQLConnection($DestConnStr)
    ReOpenConnection($tgtConn)
    $cmd1.Connection = $tgtConn
    $cmd1.ExecuteNonQuery()

    $bulkCopy = New-Object Data.SqlClient.SqlBulkCopy($DestConnStr, [System.Data.SqlClient.SqlBulkCopyOptions]::KeepIdentity)
    $bulkCopy.DestinationTableName = $DestTable
    
    $bulkcopy.columnmappings.add("Id", "Id");
    $bulkcopy.columnmappings.add("FirstName", "FirstName");
    $bulkcopy.columnmappings.add("LastName", "LastName");
    $bulkcopy.columnmappings.add("Email", "Email");
    $bulkcopy.columnmappings.add("Department", "Department");
    $bulkcopy.columnmappings.add("CreatedDate", "CreatedDate");
    $bulkcopy.batchsize = 500
    $bulkcopy.bulkcopytimeout = 600

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

    $tgtConn.Close()
    $tgtConn.Dispose()

    $cmdLogin.Dispose()

    $mastercmd.Dispose()
    $masterConn.Close()
    $masterConn.Dispose()
  }
