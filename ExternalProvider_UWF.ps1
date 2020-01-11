. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "ExternalProvider_UWF.log"
$uwfExe = "$($env:SystemDrive)\Windows\system32\uwfmgr.exe"

try {
    $output = ""
    Write-Host "UWF.LastReported=$logDateTime"
    if(!(Test-Path $uwfExe)){
        Write-Host "UWF.Installed=False`r"
    } else {
        Write-Host "UWF.Installed=True`r"
        $command = "$uwfExe get-config"
        $out = iex $command
        $outputConfig = ""
        ForEach ($str in $out){
            if($str.length -gt 1){
                $str = $str -replace "`0", "" 
                $outputConfig = $outputConfig + "$str" + "`r`n"
            }
        }
        $outputParts = $outputConfig -Split "Next Session Settings"
        $nextSessionSettings = $($outputParts[1]) -split "`r`n"
        $currentSessionSettings = $($outputParts[0]) -split "`r`n"
        ForEach ($strCurrent in $currentSessionSettings){
            if($strCurrent.ToLower() -match "filter state"){
                Write-Host "UWF.Current.Filter.Enabled=$($($($strCurrent -split ":")[1]).Trim())`r"
            } elseif($strCurrent.ToLower() -match "type:"){
                Write-Host "UWF.Current.Overlay.Type=$($($($strCurrent -split ":")[1]).Trim())`r"
            } elseif($strCurrent.ToLower() -match "maximum size:"){
                Write-Host "UWF.Current.Overlay.MaximumSize=$($($($($strCurrent -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strCurrent.ToLower() -match "warning threshold:"){
                Write-Host "UWF.Current.Overlay.WarningThreshold=$($($($($strCurrent -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strCurrent.ToLower() -match "critical threshold:"){
                Write-Host "UWF.Current.Overlay.CriticalThreshold=$($($($($strCurrent -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strCurrent.ToLower() -match "freespacepassthrough:"){
                Write-Host "UWF.Current.Overlay.FreespacePassthrough=$($($($strCurrent -split ":")[1]).Trim())`r"
            } elseif($strCurrent.ToLower() -match "persistent:"){
                Write-Host "UWF.Current.Overlay.Persistent=$($($($strCurrent -split ":")[1]).Trim())`r"
            } elseif($strCurrent.ToLower() -match "reset mode:"){
                Write-Host "UWF.Current.Overlay.ResetMode=$($($($strCurrent -split ":")[1]).Trim())`r"
            }
        }
        ForEach ($strNext in $nextSessionSettings){
            if($strNext.ToLower() -match "filter state"){
                Write-Host "UWF.Next.Filter.Enabled=$($($($strNext -split ":")[1]).Trim())`r"
            } elseif($strNext.ToLower() -match "type:"){
                Write-Host "UWF.Next.Overlay.Type=$($($($strNext -split ":")[1]).Trim())`r"
            } elseif($strNext.ToLower() -match "maximum size:"){
                Write-Host "UWF.Next.Overlay.MaximumSize=$($($($($strNext -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strNext.ToLower() -match "warning threshold:"){
                Write-Host "UWF.Next.Overlay.WarningThreshold=$($($($($strNext -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strNext.ToLower() -match "critical threshold:"){
                Write-Host "UWF.Next.Overlay.CriticalThreshold=$($($($($strNext -split ":")[1]).Trim()).Replace(' MB',''))`r"
            } elseif($strCurrent.ToLower() -match "freespacepassthrough:"){
                Write-Host "UWF.Next.Overlay.FreespacePassthrough=$($($($strNext -split ":")[1]).Trim())`r"
            } elseif($strNext.ToLower() -match "persistent:"){
                Write-Host "UWF.Next.Overlay.Persistent=$($($($strNext -split ":")[1]).Trim())`r"
            } elseif($strNext.ToLower() -match "reset mode:"){
                Write-Host "UWF.Next.Overlay.ResetMode=$($($($strNext -split ":")[1]).Trim())`r"
            }
        }
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "$logDateTime - Error $_ in line $line `r`n"
} 

