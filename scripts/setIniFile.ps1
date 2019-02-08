. "$PSScriptRoot\common.ps1"

$Logfile = $logDirectory + "setIniFile.log"
$configFile = $configDirecotry + "systemSetings.ini"
$iniFilePath = ""
$rtn = ""
try{
    if($args.length -gt 2){
        $iniFilePath = $args[0]
        if(Test-Path $iniFilePath){
            LogWrite $LogFile "Reading config file $iniFilePath"
            $iniFile = Get-IniFile $iniFilePath
            try {
                $iniSetting = $iniFile.$($args[1]).$($args[2])
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

# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+oTYi9t1WQCnmS+rZSQ9c8lv
# 3i+gggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
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
# DQEJBDEWBBQ0mONXQaqFuH/wnJMUOAS8i9psnDANBgkqhkiG9w0BAQEFAASCAQCR
# qKQAKDSgP7V0OVnlD2GzecTqsmy9fEjjAB64DlQ74XPquNFwfKjZioAuG0md/8Qb
# Dx3yVO9jhoTLlXKOjocX7psR5gquth7tPz0w4CXpZ/3GEpbX4YpUwbZLq5qdgdN+
# eZEnrMLeko4VU2CVu549+tkL8vcr85Is9QnSOsOZdqaJGTs//8dmTsQF5geuw4RU
# wbQLvX6YboTtmdo8hAagoG/KPafSD+QC+M5eZdsg41ka6in5But17wXYIsLv+BcM
# zx7BT6BIpkOQtoaE3jhNGmQMRYPkwjdaVoJFaY9aqVnFH0Gg4VwmfQBXwpFRZr4A
# W2b+MeLgz8V05J+Ek2s0
# SIG # End signature block
