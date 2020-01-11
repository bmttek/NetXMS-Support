$step=$args[0]
if($step.ToString().toLower() -match 'listfileexclusions'){
    $command = "c:\windows\system32\uwfmgr.exe file get-exclusions"
    $out = Invoke-Expression $command
    $output
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
}
if($step.ToString().toLower() -match 'listregistryexclusions'){
    $command = "c:\windows\system32\uwfmgr.exe registry get-exclusions"
    $out = Invoke-Expression $command | Out-String
    $output
    ForEach ($str in $out){
        if($str.length -gt 3){
            $str = $str -replace "`0", "" 
            $output = $output + "$str" + "`r`n"
        }
    }
    Write-Host $output
}