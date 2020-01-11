. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "setIniFile.log"
$configFile = $configDirectory + "systemSettings.ini"
$iniFilePath = ""
$rtn = ""
try{
    if($args.length -gt 2){
        $iniFilePath = $args[0]
        if(Test-Path $iniFilePath){
            $iniFile = Get-IniFile $iniFilePath
            try {
                $iniSetting = $iniFile.$($args[1]).$($args[2])
                LogWrite $LogFile "Inserting group $($args[1]) setting $($args[2]) with value $($args[3]) into file $($args[0])"
                if($iniSetting -ne $args[3]){
                    $iniFile.$($args[1]).$($args[2]) = $args[3]
                    Out-IniFile $iniFile $iniFilePath
                    Write-Host "$logDateTime - OK - Updated`n"
                } else {
                    Write-Host "$logDateTime - OK - No Update Needed`n"
                }
            } catch {
                Add-Content $iniFilePath -value "[$($args[1])]"
                Add-Content $iniFilePath -value "$($args[2])=$($args[3])"
                Write-Host "$logDateTime - Created new category and inserted setting `n"
            }
        } else {
            LogWrite $LogFile "$iniFilePath file does not exist"
            Add-Content $iniFilePath -value "[$($args[1])]"
            Add-Content $iniFilePath -value "$($args[2])=$($args[3])"
            Write-Host "$logDateTime - Created file add inserted setting `n"
        }
    } else {
        LogWrite $LogFile "Need 3 arguments filepath settingcategory settingname settingvalue"
        Write-Host "$logDateTime Need 3 arguments filepath settingcategory settingvalue`n"
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "$logDateTime - set Domain Error $_ in line $line `n"
}