$reboot="false"
try{
    $command = "";
    foreach($str in $args){
        if($str.length -gt 1){
            if($str.ToLower() -match "reboot=yes"){
                $reboot="true"
            } elseif(!($str -match "none")){
                $command = $command + " $str"
            }
        }
    }
    $out = iex $command
    $output = "***Command executed - $command *** `r`n"
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
    if($reboot -eq "true"){
        $command = "shutdown -r -t 5"
        iex $command
    }
}
catch {
    $line = $_.InvocationInfo.ScriptLineNumber
    Write-Host "Error $_ processing ini file at line $line"
}