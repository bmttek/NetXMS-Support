. "$PSScriptRoot\common.ps1"


$LogFile = $logDirectory + "featureEnableDisable.log"

$reboot = $false
try {
    $output="Arguments Passed = $args`n"
    LogWrite $LogFile "Arguments Passed = $args"
     if($args.length -gt 1){
        if($args[0].ToLower() -match "on"){
            $command = "Dism /online /Enable-Feature /FeatureName:$($args[1]) /All /NoRestart"
            $out = iex $command
        } elseif($args[0].ToLower() -match "off")  {
            $command = "Dism /online /Disable-Feature /FeatureName:$($args[1]) /NoRestart"
            $out = iex $command
        } else {
            LogWrite $LogFile "2nd argumaent invalid"
            Write-Host "$logDateTime 2nd argumaent invalid`n"
        }
        if($args.length -gt 2){
            if($args[2].ToLower() -match "reboot=yes"){
                $reboot = $true
            }
        }
        ForEach ($str in $out){
            if($str.length -gt 3){
                $str = $str -replace "`0", "" 
                $output = $output + "$str" + "`n"
            }
        }
        $command = "Dism /online /Get-FeatureInfo /FeatureName:$($args[1])"
        $out = iex $command
        ForEach ($str in $out){
            if($str.length -gt 3){
                $str = $str -replace "`0", "" 
                $output = $output + "$str" + "`n"
            }
        }
        Write-Host $output

        if($reboot){
            $command = "shutdown -r -t 10"
            iex $command
        }
     } else {
        LogWrite $LogFile "Not enough argumanets 1st ON/OFF 2nd feature name"
        Write-Host "$logDateTime Not enough argumanets 1st ON/OFF 2nd feature name `n`r"
     }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "$logDateTime - Error $_ in line $line`n"
} 