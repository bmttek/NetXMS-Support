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


# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUY7x0rON61cSRWdGioniawSFI
# 7vKgggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
# 9w0BAQsFADA+MRMwEQYKCZImiZPyLGQBGRYDb3JnMRQwEgYKCZImiZPyLGQBGRYE
# b2xwbDERMA8GA1UEAxMIb2xwbC0tQ0EwHhcNMTgxMTE4MTEzNTAzWhcNMTkxMTE4
# MTEzNTAzWjCBpTETMBEGCgmSJomT8ixkARkWA29yZzEUMBIGCgmSJomT8ixkARkW
# BG9scGwxEDAOBgNVBAsMB09VX0Jhc2UxFzAVBgNVBAsMDk9VX0RfTGFuT2ZmaWNl
# MRcwFQYDVQQLDA5PVV9EX0xPX09mZmljZTEdMBsGA1UECwwUT1VfRF9MT19PZmZp
# Y2VfVXNlcnMxFTATBgNVBAMTDE1hcmNpbiBUcnV0eTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBALmyrZpanDEK6dym5sgCr/YeMQTcy80necEtqTtkK322
# KaKj1CMQ0qD5YZFVmh/U53NG20Tslg8IJB/1yt1C5x5A1tEisUsYjhd//fgi3Eta
# nudzKEOzCdkKuh2O84RGdooNn3fyVBKvAKe3fwWZQ3hEBQZwE3cOyuSxJNMSJ2WO
# 7F14uT2IoV1gB0YQwgYbWz8XePS7EioudJc/W+C285cWD3VAM57q0Dq9B5XCQdmw
# VJGJIdwEmOy/PEVN6grhMeQdXs1lcYnWCrFq3D4sfUugfp+r3JRduMKswWhiC/my
# nkq+5f0KXC7WuRnRacBdmPhJhFTlrHNjV4Ik+6UzmmECAwEAAaOCAjgwggI0MCUG
# CSsGAQQBgjcUAgQYHhYAQwBvAGQAZQBTAGkAZwBuAGkAbgBnMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIHgDAdBgNVHQ4EFgQUIRv8nMXD3KdzoRWn
# oAP4rE7dyuMwHwYDVR0jBBgwFoAUMFzescCWVLut22FexTJYPduyqnAwgb8GA1Ud
# HwSBtzCBtDCBsaCBrqCBq4aBqGxkYXA6Ly8vQ049b2xwbC0tQ0EsQ049ZGMyLENO
# PUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1D
# b25maWd1cmF0aW9uLERDPW9scGwsREM9b3JnP2NlcnRpZmljYXRlUmV2b2NhdGlv
# bkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCBtwYI
# KwYBBQUHAQEEgaowgacwgaQGCCsGAQUFBzAChoGXbGRhcDovLy9DTj1vbHBsLS1D
# QSxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
# Q049Q29uZmlndXJhdGlvbixEQz1vbHBsLERDPW9yZz9jQUNlcnRpZmljYXRlP2Jh
# c2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAqBgNVHREEIzAh
# oB8GCisGAQQBgjcUAgOgEQwPbXRydXR5QG9scGwub3JnMA0GCSqGSIb3DQEBCwUA
# A4ICAQBFwjvXuzA2GE8PdvPPZ6zRVGGsOgvv02zDV3/wld70p78Wf5UudzhbL8fl
# jOnmimhiGmkCF7DLsVFBmZ7XGqXmls+MPHOm+4T48r4FrVLOsq6v7Z+c+2tASgXc
# OuIuR+TE02b8M3AMbYSb7LXxxCY1ePGPpxYaVaWdcB1zWRSouFJXjCmOLxGkAqHB
# SgoKV0GjEcBS/FHHSx3MBSgyfCwWb6E2hYXMs5PI9jlaTVemRZaosvsMvIBSRprH
# oQEqnx8Q8HvMOzmiDtgA+H1okrRO1oCW51WGrynLeSlhttCvejEZdBALnIw2UqWy
# jnC3NBglUxyGrbp3UyLp2Z1G66y4aGqeXAKpD/CVz8tjFo3//2g2kLG06gwMkRb3
# qF2EWmUxWrKpVAkjv6RquH76X1w0rDp3O/yQA3T5jNQtDsE3r2mIFycuaoKlbpKV
# Zfl8n0kdVh96NQvrMqP6/oZPFsgNozAHZrCTj5sRxSX3glKIBneh02+5ngby9X+b
# dL7uAmu4SpUNVWk4pGu+fSA1OmjDx7bUwp128SNE57UQ46uyWa+xchLyk9J9KG6w
# RD2uKH+mecbn78y/6kea8B3MOknb7YzFSQ6eBNrXT/UJb1l32pfD84TQ3oMO6uQX
# 0nMFiW4SvPIlRCVs3DJ8v2ZHAKGdz6Z/+X5Jpl7ZwO3JhzpvtTGCAfYwggHyAgEB
# MFUwPjETMBEGCgmSJomT8ixkARkWA29yZzEUMBIGCgmSJomT8ixkARkWBG9scGwx
# ETAPBgNVBAMTCG9scGwtLUNBAhM4AAAIH6w2z/4BwAE3AAAAAAgfMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBTtIKxxR12xu180yuS5O0Xh7CyI5zANBgkqhkiG9w0BAQEFAASCAQAj
# T49frbGlaU5Fmi/NAiKOvzD++Uz43MSHKKCZvLdoz+KlWi7Ap3Nb7HZqf1mUsHT0
# CClkiTDPHEoh0wfCfGvOCS05cVfAsV1iUpcLOk9OWuuVU1cW9WIrMFKItF/sxmTO
# bJ7DWxwBuXSDcTKZuKBSA6VXLhgF9Ol6qm30hTEuqoajr0e5PCJW4PHMbY2Jf1s1
# 6B1X7R6w61bJJlY1m8XMsBH0EtzAsnRy4EU+qSI6G2S44k6pS9KS1CfEijX1TzFg
# V4+/29jVB0VpNoXw9y3yirqgjdSe92TNp//OYyeexi0J7lpFAWVtg2d+AJs0Eu/k
# hZk9hCZG8SI9qfTn/SGl
# SIG # End signature block
