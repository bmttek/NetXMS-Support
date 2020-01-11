. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "NetXMSAgentDatabaseFix.log"
$uwfExe = "$($env:SystemDrive)\Windows\system32\uwfmgr.exe"
$configFile = $configDirectory + "uwfMaintenence.ini"
$systemFile = $configDirectory + "systemSettings.ini"
$COMPUTER = "localhost"
$NAMESPACE = "root\standardcimv2\embedded"
$rtn = ""
$addLogs = $true
$addConfig = $true
$addWinNetXMS = $true
$addFog = $true
$autoMaintenance = $false
$reboot = $false
$adminOverride = $false
$ServiceName = 'NetXMSAgentdW32'

try{
    $arrService = Get-Service -Name $ServiceName
    if ($arrService.Status -eq 'Running'){
        Stop-Service -WarningAction SilentlyContinue $ServiceName
        Start-Sleep -seconds 20
    }
    if(Test-Path "$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd\nxagentd.db"){
        Remove-Item("$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd\nxagentd.db")
        Start-Sleep -seconds 3
    }
    Start-Service -WarningAction SilentlyContinue $ServiceName
    Start-Sleep -seconds 30
    if ($arrService.Status -ne 'Running'){
        Start-Service -WarningAction SilentlyContinue $ServiceName
    }
    Start-Sleep -seconds 30
    if ($arrService.Status -ne 'Running'){
        Start-Service -WarningAction SilentlyContinue $ServiceName
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "NetXMSAgentDatabaseFix=$logDateTime - Error $_ in line $line `r"
}