. "$PSScriptRoot\common.ps1"

if(Test-Path "$env:ProgramData\chocolatey\applist\installAPPS.ini"){
    $iniInstallApps = Get-IniFile "$env:ProgramData\chocolatey\applist\installAPPS.ini"
}
if(Test-Path "$env:ProgramData\chocolatey\applist\checkAPPS.ini"){
    $iniCheckFile = Get-IniFile "$env:ProgramData\chocolatey\applist\checkAPPS.ini"
}
$chocoEXE = "$env:ProgramData\chocolatey\bin\choco.exe"
$abcUpdateEXE = "$env:ProgramData\chocolatey\lib\ABC-Update\tools\ABC-Update.exe"
$LogFile = $logDirectory + "maintChoco.log"
$configFile = $configDirectory + "systemSettings.ini"
$proxy = ""
$debug = $false
$run = $false

Write-Host "System.Maintenance.LastReported=$logDateTime"


if(checkArgumentExists $args "debug"){ $debug=$true }
if(checkArgumentExists $args "now")
{ 
    Write-Host "Entering admin override`n"
    LogWrite $LogFile "Entering admin override"
    $run = $true
}

try{
    if(!Test-Path $configFile){
        $iniFile = Get-IniFile $configFile
        $min = $iniFile.Maintenance.StartTime
        $max = $iniFile.Maintenance.StopTime
    }
} catch {
    $min = Get-Date "22:00"
    $max = Get-Date "05:00"
}
try{
    $timeCurrent = (Get-Date)
    if($timeCurrent.ToString("HHmm") -ge $min.ToString("HHmm")){
        $max=$max.AddDays(1)
    } else {
        $min = $min.AddDays(-1)
    }

    if ($timeCurrent -ge $min -and $timeCurrent -le $max) {
        #Write-Host "Entering Maintenance time`n"
        LogWrite $LogFile "Entering Maintenance time"
        $run = $true
    }

    #Write-Host "Maintenance from $min to $max`n"
    LogWrite $LogFile "Maintenance from $min to $max"

    if($run){
        #Write-Host "Checking if powershell needs proxy and setting if needed`n"
        LogWrite $LogFile "Checking if powershell needs proxy and setting if needed"
        if(Test-Path $configFile){
            try{
                $iniFile = Get-IniFile $configFile
                $proxy = $iniFile.Global.Proxy
            } catch {
                $proxy = "none"
            }
        } else {
            $proxy = "none"
        }

        if($proxy -match "none"){
            #Write-Host "No proxy server needed.  Will remove if set`n"
            LogWrite $LogFile "No proxy server needed.  Will remove if set"
            $command = "netsh winhttp reset proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        } else {
            #Write-Host "Setting proxy server to $proxy`n"
            LogWrite $LogFile "Setting proxy server to $proxy"
            $command = "netsh winhttp set proxy $proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        }
        if(!(Test-Path $chocoEXE)){
            #Write-Host "Chocolatey not installed - Installing`n"
            LogWrite $LogFile "Chocolatey not installed - Installing"
            iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
            choco feature enable -n allowGlobalConfirmation
        }
        $addLocalRepo=$false
        try{
            $command = "$chocoEXE source"
            $out = iex $command
            if(!($out -match "LocalRepo")){
                $addLocalRepo=$true
            }
            $localRepo=$iniFile.Choco.RepoUrl
            if(!($out -match $localRepo)){
                $addLocalRepo=$true
            }
            if($addLocalRepo){
                #Write-Host "Local Repository url changed or not set - Setting to $localRepo`n"
                LogWrite $LogFile "Local Repository url changed or not set - Setting to $localRepo"
                $command = "$chocoExe source remove -n=LocalRepo"
                if($debug){
                    iex $command
                } else {
                    $out = iex $command
                }
                $command = "$chocoExe source add -n=LocalRepo -s $localRepo"
                if($debug){
                    iex $command
                } else {
                    $out = iex $command
                }
            }
        } catch { }
        if($proxy -match "none"){
            #Write-Host "No choco proxy server needed.  Will remove if set`n"
            LogWrite $LogFile "No choco proxy server needed.  Will remove if set"
            $command = "$chocoEXE config unset proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        } else {
            #Write-Host "Setting choco proxy server to $proxy`n"
            LogWrite $LogFile "Setting choco proxy server to $proxy"
            $command = "$chocoEXE config set proxy $proxy"
            if($debug){
                iex $command
            } else {
                $out = iex $command
            }
        }

        Foreach ($k in $iniInstallApps.Applications){
            ForEach($l in $k.Keys){
                if($iniInstallApps["Applications"][$l].Contains('1')){
			        $packageInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($l.ToLower()) }
			        if($packageInstalled -ne $null){
			        #	Write-Host "Package $l already installed`n"
                    #    LogWrite $LogFile "Package $l already installed"
			        }
			        else {
                        #Write-Host "Package $l will be installed`n"
                        LogWrite $LogFile "Package $l will be installed"
				        $command = $chocoEXE + ' install ' + $l + ' --ignorechecksums'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
			        $packageInstalled = $null
                }
		        if($iniInstallApps["Applications"][$l].Contains('0')){
			        $packageInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($l.ToLower()) }
			        if($packageInstalled -ne $null){
                        #Write-Host "Package $l will be removed`n"
                        LogWrite $LogFile "Package $l will be removed"
				        $command = $chocoEXE + ' uninstall ' + $l + ' --ignorechecksums'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        } 
				        $command = ''
			        }
			        $packageInstalled = $null
                }
            }
        }
        #Write-Host "Upgrading all packages`n"
        LogWrite $LogFile "Upgrading all packages"
        $command = $chocoEXE + ' upgrade all' + ' --ignorechecksums'
        if($debug){
            iex $command
        } else {
            $out = iex $command
        }
        $command = ''

        echo "Removing Apps"
        Foreach ($k in $iniInstallApps.Uninstall){
            ForEach($l in $k.Keys){
                if($iniInstallApps["Uninstall"][$l].Contains('1')){
			        if ([IntPtr]::Size -eq 4) {
				        $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
			        }
			        else {
				        $regpath = @(
					        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
					        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
				        )
			        }
			        $uApps = Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString
			        foreach($uApp in $uApps){
				        if($uApp.DisplayName -like $l){
					        $command = "cmd.exe /C " + $uApp.UninstallString
					        if($debug){
                                iex $command
                            } else {
                                $out = iex $command
                            }
					        $command = ''
				        }
			        }
                }
            }
        }
        if(!(Test-Path $abcUpdateEXE)){
            #Write-Host "abc-update not found installing"
	        $command = $chocoEXE + ' install abc-update --ignorechecksums'
	        if($debug){
                iex $command
            } else {
                $out = iex $command
            }
	        $command = ''
        }
        if(Test-Path $abcUpdateEXE){
	        ForEach ($k in $iniContant.Updates){
		        ForEach ($l in $k.Keys){
			        if($iniContant["Updates"][$l].Contains('1')){
				        echo "Run " + $l + " from MS"
				        $command = $abcUpdateEXE + ' /C:' + $l +' /A:Install /Q:IsHidden=0 AND Isinstalled=0 /R:3 /Log:' + $abcUpdateLog + 'abcUpdate' + $l + '.log'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
			        if($iniContant["Updates"][$l].Contains('date')){
				        echo "Run " + $l + " from MS"
				        $date = (get-date).ToString("dd.MM.yyyy")
				        $intDaysBehind = (get-date).AddDays(-$iniContant["Updates"][$l].Replace('date','')).ToString("dd.MM.yyyy")
				        $command = $abcUpdateEXE + ' /C:' + $l +' /A:Install /Q:IsHidden=0 AND Isinstalled=0 /R:3 /D:*,' + $intDaysBehind + ' /Log:' + $abcUpdateLog + 'abcUpdate' + $l + '.log'
				        if($debug){
                            iex $command
                        } else {
                            $out = iex $command
                        }
				        $command = ''
			        }
		        }
	        }
        }
        Write-Host "System.Maintenance.Log=$logDateTime - OK"
    } else {
        Write-Host "System.Maintenance.Log=$logDateTime - Not in Maintenance Window"
    }
} catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    LogWrite $LogFile "Error $_ processing ini file at line $line"
    Write-Host "System.Maintenance.Log=$logDateTime - Error $_ in line $line"
}

# SIG # Begin signature block
# MIIJOwYJKoZIhvcNAQcCoIIJLDCCCSgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBqPhJZDc/Do8Mo/p9GjsXaib
# SAagggavMIIGqzCCBJOgAwIBAgITOAAACB+sNs/+AcABNwAAAAAIHzANBgkqhkiG
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
# DQEJBDEWBBQfDUU/D7aVdgvVKU03KrcMUY8r4jANBgkqhkiG9w0BAQEFAASCAQCD
# qDIWXou+7uheKhWwHblqtXGhx8iiNoNLqY2xR/FGrQYkVtBBUeqqqTVmLf9bptiY
# HUKxQgMD9c0ODaH7POLdIXjBLPNWXFSzuVRlIkJwIXj+aM86/cARS9N/siVuwbxP
# z2QqLlQ8KUXChAkrYSIIU/EcfEzO/RAC7Nqyblu1JhiHLtHIpIkZ2mys04Q81xwg
# Xf17O7PecD7pIdZERuXk8M60OrzLbO6ECefND9ur0BMX0Sqg/x17+5lw6Lo+JXuj
# +JQGdQ7nYn8Lc3CzwwsVTxuaCv7lt1vyt2jJRif9QtRPBa0gLELZluRs/2mZqZf0
# GC8jicU+HKK2xGfdgXWW
# SIG # End signature block
