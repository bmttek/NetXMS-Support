$step=$args[0]
$volumes = Get-WmiObject -Class UWF_Volume -Namespace root/StandardCimv2/embedded;
if($step.ToString().toLower() -match 'list'){
    $s
    ForEach($item in $volumes)
    { 
        $s = $s + $($item.VolumeName.Replace("Volume{","").Replace("}","")) + "`r`n"
    }
    echo $s;
} else {
    if(($args.Length -gt 1)){
        $vName=$args[1]
        $s = ""
        if($step.ToString().toLower() -match 'bindbydriveletter'){

            ForEach($item in $volumes)
            { 
                if($item.VolumeName -match $vName){
                    $s = $item.BindByDriveLetter
                }
            }
            
            Write-Host "$s`r`n"
        } elseif($step.ToString().toLower() -match 'commitpending'){
            ForEach($item in $volumes)
            { 
                if($item.VolumeName -match $vName){
                    $s = $item.CommitPending
                }
            }
            Write-Host "$s`r`n"
        } elseif($step.ToString().toLower() -match 'currentsession'){
            ForEach($item in $volumes)
            { 
                if($item.VolumeName -match $vName){
                    $s = $item.CurrentSession
                }
            }
            Write-Host "$s`r`n"
        } elseif($step.ToString().toLower() -match 'drivelettername'){
            ForEach($item in $volumes)
            { 
                if($item.VolumeName -match $vName){
                    $s = $item.DriveLetter
                }
            }
            Write-Host "$s`r`n"
        } elseif($step.ToString().toLower() -match 'protected'){
            ForEach($item in $volumes)
            { 
                if($item.VolumeName -match $vName){
                    $s = $item.Protected
                }
            }
            Write-Host "$s`r`n"
        }
    } else {
        Write-Host "Not enouth parameters passed"
    }
}