. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "updateScript.log"
$configFile = $configDirectory + "systemSettings.ini"
$runUpdate = $false
$gitUpdate = $false
$windowsTempDir = "$($env:SystemDrive)\Windows\temp\"
try{
    Write-Host "Agent.UpdateScripts.LastReported=$logDateTime`r"
    try{
        if(Test-Path $configFile){
            $iniFile = Get-IniFile $configFile
            if($($iniFile.GIT.URL).Length -gt 3){
                if(Test-Path "$($windowsTempDir)\common.ps1"){
                    Remove-Item "$($windowsTempDir)\common.ps1"
                }
                if(Test-Path "$($windowsTempDir)\updateThroughGit.ps1"){
                    Remove-Item "$($windowsTempDir)\updateThroughGit.ps1"
                }
                Copy-Item "$($PSScriptRoot)\common.ps1" "$($windowsTempDir)\common.ps1"
                Copy-Item "$($PSScriptRoot)\updateThroughGit.ps1" "$($windowsTempDir)\updateThroughGit.ps1"
                 $command="$($env:SystemDrive)\Windows\System32\start.exe"
                 [Array]$arguments = "-File","$($windowsTempDir)updateThroughGit.ps1"
                 Start-Process -FilePath "powershell.exe" -WorkingDirectory $windowsTempDir -ArgumentList $arguments -WindowStyle Hidden
                 $gitUpdate = $true
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
        Write-Host "Agent.UpdateScripts.Status=OK`r"
        Write-Host "Agent.UpdateScripts.LogDetails=""`r"
    }
    else{
        if($gitUpdate -eq $false){
            LogWrite $LogFile "No argument for location given"
            Write-Host "Agent.UpdateScripts.Status=No Source path argument or domain set in system settings"
        }
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "Agent.UpdateScripts.Status=Error`r"
    Write-Host "Agent.UpdateScripts.LogDetails=Error $_ in line $line `r`n"
} 

# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxYxyWCg5VZ4rHS9ABwzF4u0i
# 16mgggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
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
# DQEJBDEWBBSxPzpoEnbhX6kNMVDubbllwRepTTANBgkqhkiG9w0BAQEFAASCAQBx
# c7zT5vKLjA266o/69UEtMiwj8W4lwGz29qJvOQ2pfShWanfPgpBPxTGPsqA7qnXF
# QQx4+jQzbVn4fnmKzpb508mJHjbma0DYZxDTSTeagKiiwt3twLqVqM8tznxdyfF8
# 1kAPAg8eaf0iOmrCvvjUsPVVecz05ceX9wzpA9GTAINpaUEaA+05wjVDW/aY/hLC
# C7PXy+S7/sHPNuhfoj+VQIgTaHNce5h4SOgpyYsNxNrcYMa2/3gguMH83wtzSQGj
# L7eVvVJH7FrlUQWxV/W0MFGYTwub5u/h9yAV3ktvd6wP18FrxVyi+PqDlGCUmFb6
# QVGmMzK9iL8E/Fpj2QCQ
# SIG # End signature block
