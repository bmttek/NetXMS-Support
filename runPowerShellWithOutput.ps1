. "$PSScriptRoot\common.ps1"

$LogFile = $logDirectory + "runPowershellSCRIPT.log"
$reboot="false"
try{
    $command = "powershell ";
    foreach($str in $args){
        if ($str -match "^\d+$"){
            $command = $command + " $str"
        } elseif($str.length -gt 1){
            if($str.ToLower() -match "reboot=yes"){
                $reboot="true"
            } elseif(($str -match "%%")){
                $spl = @($str.Split("%%"))
                $env1 = [Environment]::GetEnvironmentVariable($($spl[1]))
                $str = $str.Replace("%%$($spl[1])%%",$env1)
                $command = $command + " $str"
            } elseif(!($str -match "none")){
                if(($str -match "%")){
                    $str = $str.Replace("%","")
                }
                $command = $command + " $str"
            }
        }
    }
    LogWrite $LogFile "Running command-$command"
    $out = iex $command
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    #$output = $output.Trim()
    Write-Host "$output"
    if($reboot -eq "true"){
        $command = "shutdown -r -t 5"
        iex $command
    }
}
catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    Write-Host "Error $_ processing ini file at line $line"
    LogWrite $LogFile "Error $_ processing ini file at line $line"
}