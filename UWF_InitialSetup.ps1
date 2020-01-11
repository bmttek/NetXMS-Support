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
