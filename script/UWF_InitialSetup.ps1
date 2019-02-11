#Customer Experience Improvement Program (CEIP) exclusions
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SQMClient\Windows\CEIPEnable'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\Windows\CEIPEnable'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\UploadDisableFlag'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
#Background Intelligent Transfer Service (BITS)
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\BITS\StateIndex'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ALLUSERSPROFILE)\Microsoft\Network\Downloader'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
# Wireless Networks
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Wireless\GPTWirelessPolicy'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WiredL2\GP_Policy'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
#Network GPO Policy Settings
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:SystemDrive)\Windows\wlansvc\Policies'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:SystemDrive)\Windows\dot2svc\Policies'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:SystemDrive)\Windows\System32\config\systemprofile\AppData\Local\nxagentd'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
#Interface profile registry keys
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\wlansvc'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\dot3svc'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
#INterface policy files
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ProgramData)\Microsoft\wlansvc\Profiles\Interfaces\{<Interface GUID>}\{<Profile GUID>}.xml'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ProgramData)\Microsoft\dot3svc\Profiles\Interfaces\{<Interface GUID>}\{<Profile GUID>}.xml'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
#system Setup
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion `"$(${env:ProgramFiles(x86)})\Fog`""
$out = iex $command
$output = "***Command executed - $command *** `r`n"
ForEach ($str in $out){
    if($str.length -gt 3){
        $str = $str -replace "`0", "" 
        $output = $output + "$str" + "`r`n"
    }
}
Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ProgramData)\Logs'"
$out = iex $command
$output = "***Command executed - $command *** `r`n"
ForEach ($str in $out){
    if($str.length -gt 3){
        $str = $str -replace "`0", "" 
        $output = $output + "$str" + "`r`n"
    }
}
Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ProgramData)\Config'"
$out = iex $command
$output = "***Command executed - $command *** `r`n"
ForEach ($str in $out){
    if($str.length -gt 3){
        $str = $str -replace "`0", "" 
        $output = $output + "$str" + "`r`n"
    }
}
Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe file add-exclusion '$($env:ProgramData)\Netxms'"
$out = iex $command
$output = "***Command executed - $command *** `r`n"
ForEach ($str in $out){
    if($str.length -gt 3){
        $str = $str -replace "`0", "" 
        $output = $output + "$str" + "`r`n"
    }
}
Write-Host $output
#Network Services
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Wlansvc'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\WwanSvc'"
iex $command
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\dot3svc'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
# Daylight savings time
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe registry add-exclusion 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones'"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
# Setup Overlay 
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe overlay set-type Disk"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe overlay set-size 16500"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe overlay set-warningthreshold 14000"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe overlay set-criticalthreshold 15000"
$out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output

$command = "$($env:SystemDrive)\windows\system32\uwfmgr.exe volume protect all"
iex $command


if(!(Test-Path "$($env:ProgramData)\Config")){
    New-Item -Path "$($env:ProgramData)\Config" -ItemType Directory
}
if(Test-Path "$($env:ProgramData)\Config\uwfMaintenence.ini"){
    Remove-Item "$($env:ProgramData)\Config\uwfMaintenence.ini"
}
Add-Content -Path "$($env:ProgramData)\Config\uwfMaintenence.ini" -Value "[Global]"
Add-Content -Path "$($env:ProgramData)\Config\uwfMaintenence.ini" -Value "adminOverride=true"
Add-Content -Path "$($env:ProgramData)\Config\uwfMaintenence.ini" -Value "initial=true"
Add-Content -Path "$($env:ProgramData)\Config\uwfMaintenence.ini" -Value "[Working]"
Add-Content -Path "$($env:ProgramData)\Config\uwfMaintenence.ini" -Value "autoMaint="

Write-Host "Done with initial setup script"

# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8jJS9tjiyUZ8wibfFlNXRjQ5
# HVigggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
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
# DQEJBDEWBBS3xxdRBs0S2CmdDG072mIDQuK1czANBgkqhkiG9w0BAQEFAASCAQBt
# AxBA9ICktZsbVTHl1NhrgIHodsMpsEoukrWulAThQszq7FuzDsIE6Dkcq7Z0v+hG
# WDUiPsgiqqpN0M/+ujq3biVJs5e5P59tByhiOiZEDFsPzdHfSuxHcZsi8xWEDMbZ
# yutx9dBiESQW/mlXwikSIsLF0vNZk4n8kyRdxZmkAn6c1LpPTfwvgBFWOyh7Or2k
# 4m5uDXdwkNlStMp4/iTIQFOSuRw9l5c0xOCQ+rjDsZMj4pZCAysVj3AQqpZGMazp
# DgbIK+AKd6mN/wEIlYRLZ8anoUBP68NS8Mm62R7h90pMq/l+9gqAqOW4KpBPCawZ
# VBD4IKU+3WKTsvXrW6yf
# SIG # End signature block
