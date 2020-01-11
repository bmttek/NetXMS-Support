Function LogWrite([String] $logFileNow, [String] $logstring) 
{
        $tempTime = [DateTime]::Now.ToString("yyyyMMddHHmmss")
        Add-content $logFileNow -value "$tempTime - $logstring"
}
function checkArgumentExists($arguments, $str){
    foreach ($inStr in $arguments){
        if($inStr.ToLower() -eq $str.ToLower()){
            return $true
        }
    }
    return $false
}
function Out-IniFile($InputObject, $FilePath)
{
    if(Test-Path $FilePath){
        Remove-Item $FilePath
    }
    $outFile = New-Item -ItemType file -Path $Filepath
    foreach ($i in $InputObject.keys)
    {
        if (!($($InputObject[$i].GetType().Name) -eq "Hashtable"))
        {
            #No Sections
            Add-Content -Path $outFile -Value "$i=$($InputObject[$i])"
        } else {
            #Sections
            Add-Content -Path $outFile -Value "[$i]"
            Foreach ($j in ($InputObject[$i].keys | Sort-Object))
            {
                if ($j -match "^Comment[\d]+") {
                    Add-Content -Path $outFile -Value "$($InputObject[$i][$j])"
                } else {
                    Add-Content -Path $outFile -Value "$j=$($InputObject[$i][$j])" 
                }

            }
            Add-Content -Path $outFile -Value ""
        }
    }
}
Function Get-InstalledApps {
    if ([IntPtr]::Size -eq 4) {
        $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    }
    else {
        $regpath = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
    }
    Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |Sort DisplayName
}
Function RemoveApp {
    if ([IntPtr]::Size -eq 4) {
        $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    }
    else {
        $regpath = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
    }
    Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |Sort DisplayName
}
function Get-IniFile 
{  
    param(  
        [parameter(Mandatory = $true)] [string] $filePath  
    )  

    $anonymous = "NoSection"

    $ini = @{}  
    switch -regex -file $filePath  
    {  
        "^\[(.+)\]$" # Section  
        {  
            $section = $matches[1]  
            $ini[$section] = @{}  
            $CommentCount = 0  
        }  

        "^(;.*)$" # Comment  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $value = $matches[1]  
            $CommentCount = $CommentCount + 1  
            $name = "Comment" + $CommentCount  
            $ini[$section][$name] = $value  
        }   

        "(.+?)\s*=\s*(.*)" # Key  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $name,$value = $matches[1..2]  
            $ini[$section][$name] = $value  
        }  
    }  

    return $ini  
}  
function UWF-CheckSettings($strQ, $out)
{
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
        if($strCurrent.ToLower() -match $strQ){
            return $($($($($strCurrent -split ":")[1]).Trim()).Replace(' MB',''))
        } 
    }
    return "none"
}

$logDateTime = [DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
$logDirectory = "$($env:ProgramData)\Logs\"
$configDirectory = "$($env:ProgramData)\Config\"
$LogFile = $logDirectory + "common.log"
$configFile = $configDirectory + "systemSetings.ini"
$logFileDateTime = [DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")


if(!(Test-Path $logDirectory)){
    New-Item $logDirectory -ItemType Directory
}
if(!(Test-Path $configDirectory)){
    New-Item $configDirectory -ItemType Directory
}
