. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "uwfMainScript.log"
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

try{
    if(Test-Path $uwfEXE){
        Write-Host "UWF.Maintenence.LastReported=$logDateTime`r"
        $command = "$uwfExe file get-exclusions"
        $out = iex $command 
        foreach($outStr in $out){
            $outStr = $outStr -replace "`0", "" 
            if($outStr -like "*$($env:ProgramData)\Logs*") { $addLogs=$false }
            if($outStr -like "*$($env:ProgramData)\Config*") { $addConfig=$false }
            if($outStr -like "*$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd*") { $addWinNetXMS=$false }
            if($outStr -like "*$(${env:ProgramFiles(x86)})\Fog*") { $addFog=$false }
        }
        if($addLogs)
        {  
            LogWrite $LogFile "Adding log directory exclusion"
            $command = "$uwfExe file add-exclusion $($env:ProgramData)\Logs"
            $out = iex $command
        }
        if($addConfig)
        {  
            LogWrite $LogFile "Adding config directory exclusion"
            $command = "$uwfExe file add-exclusion $($env:ProgramData)\Config"
            $out = iex $command
        }
        if($addWinNetXMS)
        {  
            LogWrite $LogFile "Adding netxms systemprofile directory exclusion"
            $command = "$uwfExe file add-exclusion $($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd"
            $out = iex $command
        }
        if($addFog)
        {  
            LogWrite $LogFile "Adding fog directory exclusion"
            $command = "$uwfExe file add-exclusion `"$(${env:ProgramFiles(x86)})\Fog`""
            $out = iex $command
        }
        try{
            if((Test-Path $systemFile)){
                $iniSystemFile = Get-IniFile $systemFile
                $min = Get-Date $iniSystemFile.Maintenance.StartTime
                $max = Get-Date $iniSystemFile.Maintenance.StopTime
            }
        } catch {
            $min = Get-Date "22:00"
            $max = Get-Date "05:00"
        }
        try{
            if((Test-Path $systemFile)){
                $iniSystemFile = Get-IniFile $systemFile
                $command = "$uwfExe get-config"
                $outConfig = iex $command
                $strMatch = UWF-CheckSettings "type:" $outConfig
                if(!($($($iniSystemFile.UWF.OverlayType).ToLower()) -match $($strMatch.ToLower()))) {
                    $command = "$uwfExe overlay set-type $($iniSystemFile.UWF.OverlayType)"
                    $out = iex $command
                }
                $strMatch = UWF-CheckSettings "maximum size:" $outConfig
                if(!($($($iniSystemFile.UWF.OverlaySize).ToLower()) -match $($strMatch.ToLower()))) {
                    $command = "$uwfExe overlay set-size $($iniSystemFile.UWF.OverlaySize)"
                    $out = iex $command
                }
                $strMatch = UWF-CheckSettings "critical threshold:" $outConfig
                if(!($($($iniSystemFile.UWF.OverlayCritical).ToLower()) -match $($strMatch.ToLower()))) {
                    $command = "$uwfExe overlay set-criticalthreshold $($iniSystemFile.UWF.OverlayCritical)"
                    $out = iex $command
                }
                $strMatch = UWF-CheckSettings "warning threshold:" $outConfig
                if(!($($($iniSystemFile.UWF.OverlayWarning).ToLower()) -match $($strMatch.ToLower()))) {
                    $command = "$uwfExe overlay set-warningthreshold $($iniSystemFile.UWF.OverlayWarning)"
                    $out = iex $command
                }
            }
        } catch {
            $line = $_.InvocationInfo.ScriptLineNumber
            LogWrite $LogFile "Error $_ processing comapre UWF setting at line $line"
            Write-Host "Error $_ processing comapre UWF setting at line $line"
        }
        $timeCurrent = (Get-Date)
        if($timeCurrent.ToString("HHmm") -ge $min.ToString("HHmm")){
            $max=$max.AddDays(1)
        } else {
            $min = $min.AddDays(-1)
        }
        Write-Host "UWF.Maintenence.Window=$min to $max`r"
        LogWrite $LogFile "Maintenance period from $min to $max"
        $rtn = $rtn +  "$logDateTime Maintenance period from $min to $max"
        if(Test-Path $configFile){
            LogWrite $LogFile "Reading config file $configFile"
            $iniFile = Get-IniFile $configFile
            $autoMaintenance = [bool]$iniFile.Working.autoMaint
            $adminOverride = [bool]$iniFile.Global.adminOverride
        } else {
            LogWrite $LogFile "$configFile Config file does not exist"
            $rtn = $rtn + " - Could not read config file - $configFile"
            $autoMaintenance = $false
        }
        if(!($adminOverride)){ 
            $objUWFInstance = Get-WmiObject -Namespace $NAMESPACE -Class UWF_Filter;
            if ($timeCurrent -ge $min -and $timeCurrent -le $max) {
                if($($objUWFInstance.CurrentEnabled)){
                    $command = "$uwfExe filter disable"
                    $outTemp = iex $command
                    LogWrite $LogFile "Entering Maintenance window"
                    Write-Host "UWF.Maintenence.CurrentState=Entering Maintenance window`r"
                    $rtn = $rtn + " - Entering Maintenance window"
                    $iniFile.Working.autoMaint = "true"
                    $reboot = $true
                } else {
                    Write-Host "UWF.Maintenence.CurrentState=In Maintenance window`r"
                    LogWrite $LogFile "In Maintenance window"
                    $rtn = $rtn + " - In Maintenance window"
                }
            } else {
                if(!($($objUWFInstance.CurrentEnabled))){
                        $command = "$uwfExe filter enable"
                        $outTemp = iex $command
                        Write-Host "UWF.Maintenence.CurrentState=Exiting Maintenance window`r"
                        LogWrite $Logfile "Exiting Maintenance window"
                        $rtn = $rtn + " - Exiting Maintenance window"
                        $reboot = $true
                } else {
                    LogWrite $Logfile "Disgarding changes"
                    Write-Host "UWF.Maintenence.CurrentState=Disgarding changes`r"
                    $rtn = $rtn + " - Disgarding changes"
                }
            }
        } else {
            $objUWFInstance = Get-WmiObject -Namespace $NAMESPACE -Class UWF_Filter;
            if($($objUWFInstance.CurrentEnabled)){
                $command = "$uwfExe filter disable"
                $outTemp = iex $command
                LogWrite $LogFile "Entering Admin Maintenance"
                Write-Host "UWF.Maintenence.CurrentState=Entering Admin Maintenance`r"
                $rtn = $rtn + " - Entering Admin Maintenance"
                $reboot = $true
            } else {
                Write-Host "UWF.Maintenence.CurrentState=In Admin Maintenance`r"
                LogWrite $LogFile "In Admin Maintenance"
                $rtn = $rtn + " - In Admin Maintenance"
            }
        }
        Out-IniFile $iniFile $configFile
        Write-Host "UWF.Maintenence.LogDetails=$rtn`r"
        if($reboot){
            $command = "shutdown -r -t 5"
            iex $command
        }
        Write-Host "UWF.Maintenence.Log=OK`r"
    } else {
        Write-Host "UWF.Maintenence.Log=Not Appicable`r"
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "UWF.Maintenence.LogDetails=$logDateTime - Error $_ in line $line `r"
}