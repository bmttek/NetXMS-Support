. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "updateScript.log"
$configFile = $configDirectory + "systemSettings.ini"
$runUpdate = $false
$gitUpdate = $false
$windowsTempDir = "$($env:SystemDrive)\Windows\temp\"
$scriptLocation = "$($env:ProgramData)\NetXMS\script"
$logDetails = ""
$logStatus = ""
try{
    Write-Host "Agent.UpdateScripts.LastReported=$logDateTime`r"
    try{
        if(Test-Path $configFile){
            $iniFile = Get-IniFile $configFile
            if($($iniFile.GIT.URL).Length -gt 3){
                try{
                    if(Test-Path $configFile){
                        LogWrite $LogFile "Started update git script YAYAY"
                        $iniFile = Get-IniFile $configFile
                        $gitPath = "$($env:Programfiles)\Git\bin\git.exe"
                        if(Test-Path $gitPath){
                            $gitUpdate=$true
                            if( (Get-ChildItem C:\temp | Measure-Object).Count -lt 2)
                            {
                                Set-Location $scriptLocation
                                $command="$gitPath"
                                [Array]$arguments = "pull"
                                $output = [string] (& $command $arguments 2>&1)
                                $logDetails = "$logDetails Update through git with result -- $output" 
                                if($output -Match "error"){
                                    $logStatus = "Error"
                                } else {
                                    $logStatus = "OK"
                                }  
                            } else {
                                Remove-Item -Recurse -Path $scriptLocation
                                $command="$gitPath"
                                [Array]$arguments = "clone","$($iniFile.GIT.URL)","$scriptLocation"
                                $output =  [string] (& $command $arguments 2>&1)
                                $logDetails = "$logDetails Clone through git with result -- $output" 
                                if($output -Match "error"){
                                    $logStatus = "Error"
                                } else {
                                    $logStatus = "OK"
                                }
                            }
                        } else {
                            $logDetails = "$logDetails Update through git Git not found on this computer" 
                            $logStatus = "Error"
                        }

                    }
                } catch {
                    $line = $_.InvocationInfo.ScriptLineNumber
                    $logDetails = "$logDetails Update through git Error $_ in line $line" 
                    $logStatus = "Error"
                    LogWrite $LogFile "Error $_ processing ini file at line $line"
                }
            } else {
                $sourcePath = "\\$($iniFile.Global.Domain)\sysvol\$($iniFile.Global.Domain)\scripts\NetXMS\"
                $runUpdate = $true
            }
        } else {
            if($args.Length -ge 1){
                $runUpdate = $true
                $sourcePath = $args[0]
            }
        }
    } catch {
        if($args.Length -ge 1){
            $runUpdate = $true
            $sourcePath = $args[0]
        }
    }
    if($runUpdate){
        $destPath = $PSScriptRoot
        $sourcePath = $sourcePath.Replace("\\\","\\")
        $sourceFiles = Get-ChildItem($sourcePath)
        foreach($item in $sourceFiles)
        {
            if($item){
                $copy = "false"
                if(!($item.PSIsContainer)){
                    if(Test-Path "$($destPath)\$($item)"){
                        try{
                            $diff = compare-object -ReferenceObject $(get-content $($item.FullName)) -DifferenceObject $(get-content "$($destPath)\$($item)")
                            if($($diff.Length) -gt 0) {
                                $copy = "true"
                            }
                        } catch {
                            Remove-Item "$($destPath)\$($item)"
                            $copy = "true"
                        }    
                    } else {
                        $copy = "true"
                    }
                }
                if($copy -eq "true"){
                    Copy-Item $($item.FullName) "$($destPath)\$($item)"
                    #LogWrite "copied $item to $($destPath)"
                }
            } 
        }
        $logStatus = "OK"
    }
    else{
        if($gitUpdate -eq $false){
            $logDetails = "$logDetails No Source path argument or domain set in system settings" 
            $logStatus = "Error"
            LogWrite $LogFile "No argument for location given"
        }
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    $logDetails = "$logDetails Update through git Error $_ in line $line" 
    $logStatus = "Error"
} 
Write-Host "Agent.UpdateScripts.Status=$logStatus`r"
Write-Host "Agent.UpdateScripts.LogDetails=$logDetails`r`n"