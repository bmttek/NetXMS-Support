. "$PSScriptRoot\common.ps1"

if(Test-Path "$env:ProgramData\chocolatey\applist\installAPPS.ini"){
    $iniInstallApps = Get-IniFile "$env:ProgramData\chocolatey\applist\installAPPS.ini"
}
if(Test-Path "$env:ProgramData\chocolatey\applist\checkAPPS.ini"){
    $iniCheckFile = Get-IniFile "$env:ProgramData\chocolatey\applist\checkAPPS.ini"
}
$chocoEXE = "$env:ProgramData\chocolatey\bin\choco.exe"
$abcUpdateEXE = "$env:ProgramData\chocolatey\lib\ABC-Update\tools\ABC-Update.exe"
$LogFile = $logDirectory + "maintChoco.log"
$configFile = $configDirectory + "systemSettings.ini"
$proxy = ""
$debug = $false
$run = $false

Write-Host "System.Maintenance.LastReported=$logDateTime"


if(checkArgumentExists $args "debug"){ $debug=$true }
if(checkArgumentExists $args "now")
{ 
    Write-Host "Entering admin override`n"
    LogWrite $LogFile "Entering admin override"
    $run = $true
}

try{
    if(!Test-Path $configFile){
        $iniFile = Get-IniFile $configFile
        $min = $iniFile.Maintenance.StartTime
        $max = $iniFile.Maintenance.StopTime
    }
} catch {
    $min = Get-Date "22:00"
    $max = Get-Date "05:00"
}
try{
    $timeCurrent = (Get-Date)
    if($timeCurrent.ToString("HHmm") -ge $min.ToString("HHmm")){
        $max=$max.AddDays(1)
    } else {
        $min = $min.AddDays(-1)
    }

    if ($timeCurrent -ge $min -and $timeCurrent -le $max) {
        #Write-Host "Entering Maintenance time`n"
        LogWrite $LogFile "Entering Maintenance time"
        $run = $true
    }
    # Check netXMS agent DB file for more then 5 hours old and reset if bad
    if(Test-Path "$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd\nxagentd.db"){
        $lastWrite = (get-item "$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd\nxagentd.db").LastWriteTime
        $timespan = new-timespan -days 0 -hours 5 -minutes 0
        if (((get-date) - $lastWrite) -gt $timespan) {
            if ($arrService.Status -eq 'Running'){
                Stop-Service -WarningAction SilentlyContinue $ServiceName
                Start-Sleep -seconds 20
            }
            Remove-Item("$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd\nxagentd.db")
            Start-Sleep -seconds 3
            Start-Service -WarningAction SilentlyContinue $ServiceName
            Start-Sleep -seconds 30
            if ($arrService.Status -ne 'Running'){
                Start-Service -WarningAction SilentlyContinue $ServiceName
            }
            Start-Sleep -seconds 30
            if ($arrService.Status -ne 'Running'){
                Start-Service -WarningAction SilentlyContinue $ServiceName
            }
        }
    }

    #Write-Host "Maintenance from $min to $max`n"
    LogWrite $LogFile "Maintenance from $min to $max"

    if($run){
        #Write-Host "Checking if powershell needs proxy and setting if needed`n"
        LogWrite $LogFile "Checking if powershell needs proxy and setting if needed"
        if(Test-Path $configFile){
            try{
                $iniFile = Get-IniFile $configFile
                $proxy = $iniFile.Global.Proxy
            } catch {
                $proxy = "none"
            }
        } else {
            $proxy = "none"
        }

        if($proxy -match "none"){
            #Write-Host "No proxy server needed.  Will remove if set`n"
            LogWrite $LogFile "No proxy server needed.  Will remove if set"
            $command = "netsh winhttp reset proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        } else {
            #Write-Host "Setting proxy server to $proxy`n"
            LogWrite $LogFile "Setting proxy server to $proxy"
            $command = "netsh winhttp set proxy $proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        }
        if(!(Test-Path $chocoEXE)){
            #Write-Host "Chocolatey not installed - Installing`n"
            LogWrite $LogFile "Chocolatey not installed - Installing"
            iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
            choco feature enable -n allowGlobalConfirmation
        }
        $addLocalRepo=$false
        try{
            $command = "$chocoEXE source"
            $out = iex $command
            if(!($out -match "LocalRepo")){
                $addLocalRepo=$true
            }
            $localRepo=$iniFile.Choco.RepoUrl
            if(!($out -match $localRepo)){
                $addLocalRepo=$true
            }
            if($addLocalRepo){
                #Write-Host "Local Repository url changed or not set - Setting to $localRepo`n"
                LogWrite $LogFile "Local Repository url changed or not set - Setting to $localRepo"
                $command = "$chocoExe source remove -n=LocalRepo"
                if($debug){
                    iex $command
                } else {
                    $out = iex $command
                }
                $command = "$chocoExe source add -n=LocalRepo -s $localRepo"
                if($debug){
                    iex $command
                } else {
                    $out = iex $command
                }
            }
        } catch { }
        if($proxy -match "none"){
            #Write-Host "No choco proxy server needed.  Will remove if set`n"
            LogWrite $LogFile "No choco proxy server needed.  Will remove if set"
            $command = "$chocoEXE config unset proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        } else {
            #Write-Host "Setting choco proxy server to $proxy`n"
            LogWrite $LogFile "Setting choco proxy server to $proxy"
            $command = "$chocoEXE config set proxy $proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        }

        Foreach ($k in $iniInstallApps.Applications){
            ForEach($l in $k.Keys){
                if($iniInstallApps["Applications"][$l].Contains('1')){
			        $packageInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($l.ToLower()) }
			        if($packageInstalled -ne $null){
			        #	Write-Host "Package $l already installed`n"
                    #    LogWrite $LogFile "Package $l already installed"
			        }
			        else {
                        #Write-Host "Package $l will be installed`n"
                        LogWrite $LogFile "Package $l will be installed"
				        $command = $chocoEXE + ' install ' + $l + ' --ignorechecksums'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
			        $packageInstalled = $null
                }
		        if($iniInstallApps["Applications"][$l].Contains('0')){
			        $packageInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($l.ToLower()) }
			        if($packageInstalled -ne $null){
                        #Write-Host "Package $l will be removed`n"
                        LogWrite $LogFile "Package $l will be removed"
				        $command = $chocoEXE + ' uninstall ' + $l + ' --ignorechecksums'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        } 
				        $command = ''
			        }
			        $packageInstalled = $null
                }
            }
        }
        #Write-Host "Upgrading all packages`n"
        LogWrite $LogFile "Upgrading all packages"
        $command = $chocoEXE + ' upgrade all' + ' --ignorechecksums'
        if($debug){
            iex $command
        } else {
            $out = iex $command
        }
        $command = ''

        echo "Removing Apps"
        Foreach ($k in $iniInstallApps.Uninstall){
            ForEach($l in $k.Keys){
                if($iniInstallApps["Uninstall"][$l].Contains('1')){
			        if ([IntPtr]::Size -eq 4) {
				        $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
			        }
			        else {
				        $regpath = @(
					        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
					        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
				        )
			        }
			        $uApps = Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString
			        foreach($uApp in $uApps){
				        if($uApp.DisplayName -like $l){
					        $command = "cmd.exe /C START /MIN" + $uApp.UninstallString + " && exit"
					        if($debug){
                                iex $command
                            } else {
                                $out = iex $command
                            }
					        $command = ''
				        }
			        }
                }
            }
        }
        if(!(Test-Path $abcUpdateEXE)){
            #Write-Host "abc-update not found installing"
	        $command = $chocoEXE + ' install abc-update --ignorechecksums'
	        if($debug){
                iex $command
            } else {
                $out = iex $command
            }
	        $command = ''
        }
        if(Test-Path $abcUpdateEXE){
	        ForEach ($k in $iniContant.Updates){
		        ForEach ($l in $k.Keys){
			        if($iniContant["Updates"][$l].Contains('1')){
				        echo "Run " + $l + " from MS"
				        $command = $abcUpdateEXE + ' /C:' + $l +' /A:Install /Q:IsHidden=0 AND Isinstalled=0 /R:3 /Log:' + $abcUpdateLog + 'abcUpdate' + $l + '.log'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
			        if($iniContant["Updates"][$l].Contains('date')){
				        echo "Run " + $l + " from MS"
				        $date = (get-date).ToString("dd.MM.yyyy")
				        $intDaysBehind = (get-date).AddDays(-$iniContant["Updates"][$l].Replace('date','')).ToString("dd.MM.yyyy")
				        $command = $abcUpdateEXE + ' /C:' + $l +' /A:Install /Q:IsHidden=0 AND Isinstalled=0 /R:3 /D:*,' + $intDaysBehind + ' /Log:' + $abcUpdateLog + 'abcUpdate' + $l + '.log'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
		        }
	        }
        }
        Write-Host "System.Maintenance.Log=$logDateTime - OK"
    } else {
        Write-Host "System.Maintenance.Log=$logDateTime - Not in Maintenance Window"
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "System.Maintenance.Log=$logDateTime - Error $_ in line $line"
}