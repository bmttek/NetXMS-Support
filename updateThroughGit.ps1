. "$PSScriptRoot\common.ps1"
$LogFile = $logDirectory + "updateScript.log"
$configFile = $configDirectory + "systemSettings.ini"
$scriptLocation = "$($env:ProgramData)\NetXMS\script"
try{
        if(Test-Path $configFile){
            $iniFile = Get-IniFile $configFile
            $gitPath = "$($env:Programfiles)\Git\bin\git.exe"
            if(Test-Path $gitPath){
                 $command="$gitPath "
                $output = iex $command
            } else {
                Write-Host "Agent.UpdateScripts.Status=Error-Git not found on this computer`r"
            }


            $sourcePath = "\\$($iniFile.Global.Domain)\sysvol\$($iniFile.Global.Domain)\scripts\NetXMS\"
        }
    } catch {
        $line = $_.InvocationInfo.ScriptLineNumber
        LogWrite $LogFile "Error $_ processing ini file at line $line"
        Write-Host "Agent.UpdateScripts.Status=Error`r"
        Write-Host "Agent.UpdateScripts.LogDetails=Error $_ in line $line `r`n"
    }