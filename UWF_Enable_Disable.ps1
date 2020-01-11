. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "uwfEnableDisable.log"
$uwfExe = "$($env:SystemDrive)\Windows\system32\uwfmgr.exe"
$configFile = $configDirectory + "uwfMaintenence.ini"
$COMPUTER = "localhost"
$NAMESPACE = "root\standardcimv2\embedded"
$rtn = ""

try{
    if($args.Length -gt 0){
        $iniFile = Get-IniFile $configFile
        if($($args[0]).ToString().ToLower() -like "enable"){
            try{
                $iniFile.Global.adminOverride = ""
                $command="$uwfExe filter enable"
                $output = iex $command
                Out-IniFile $iniFile $configFile
                Write-Host "UWF Filter Enabled and removed admin override`r"
                $command = "shutdown -r -t 5"
                $output = iex $command
            } catch {
                if(Test-Path $configFile){
                    Remove-Item $configFile
                }
                Add-Content $configFile -Value "[Global]"
                Add-Content $configFile -Value "adminOverride="
                Add-Content $configFile -Value "[Working]"
                Add-Content $configFile -Value "autoMaint="
            }
        } elseif ($($args[0]).ToString().ToLower() -like "disable"){
            try {
                $iniFile.Global.adminOverride = "true"
                $command="$uwfExe filter disable"
                $output = iex $command
                Out-IniFile $iniFile $configFile
                Write-Host "UWF Filter Disabled and set admin override`r"
                $command = "shutdown -r -t 5"
                $output = iex $command
            } catch {
                if(Test-Path $configFile){
                    Remove-Item $configFile
                }
                Add-Content $configFile -Value "[Global]"
                Add-Content $configFile -Value "adminOverride=true"
                Add-Content $configFile -Value "[Working]"
                Add-Content $configFile -Value "autoMaint="
            }
        } else {
            Write-Host "Invalid argument given: $($args[0])`r"
        }
    } else {
        Write-Host "No arguments given`r"
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "Error processing script Enable/Disable - Error $_ in line $line`r"
}