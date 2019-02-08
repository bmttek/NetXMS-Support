. "$PSScriptRoot\common.ps1"

$Logfile = $logDirectory + "ExternalProvider_UWF.log"
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
    LogWrite $Logfile "Error $_ processing ini file at line $line"
    Write-Host "$logDateTime - Error $_ in line $line `r`n"
} 

# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUbiU8CXQcvQ8UFQCuCGI0xJib
# ycqgggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
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
# DQEJBDEWBBRAOVCdtA62S4ORStgsXkNFEbcoXjANBgkqhkiG9w0BAQEFAASCAQC3
# Q9dYeuzvuWPQ97Z9oyi02BiKOICeYWfQeAngpimCpL+NOohw8UONtUndqjQBJopl
# /YV5u2kuJ5mHqP1pq4QQuTRlF8PxY7AcoLXdZP+X3hpsfER6aMnRlBmOHi/mmecC
# 0fxk9I7Mi5XLCWxl/6Y26dDww3w5gu8sdKyVVB9pMxmzIth7v3rvoWPrgTdNw2Wx
# ktGw/6uqVnbC6OyGheGCFcOLN9VQNQ2qRXWC2qTdMOxvmmmmtkczdfVCECMlW69M
# 2TWtwN6IPB1yzQy+kOgm6Y3GmQlJnIFkEg88K7XZYIZlJdmOZt+7IQGDXs8l/CdL
# dqvaw7zDgIo/SyaaSPWV
# SIG # End signature block
