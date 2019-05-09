$srcVCs = "vcenter1","vcenter2"
$vDSConfigPath = "E:\Data\VCBackup\dSwitch\"
$date = (Get-Date).ToString('MM-dd-yy-hh-mm')

Foreach ($vc in $srcVCs){

    Connect-VIServer $vc
    $vDSwitches = Get-VDSwitch

    Write-Host ("")
    Write-Host ("Exporting distributed switches on ") $vc -ForegroundColor Cyan 
    Write-Host ("")
 
    ForEach ($vDS in $vDSwitches){
        write-host "Exporting switch " $vDS.name
        $dir = $vDSConfigPath + $vDS.name

        # check if folder exists otherwise create
        if(!(Test-Path -Path $dir)){
            New-Item -ItemType directory -Path $dir
            Write-Host "New folder created " + $dir
        }

        # delete files older then 60 days
        Get-ChildItem –Path $dir -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-60))} | Remove-Item

        $file = $dir + "\" + $date + "-" + $vDS.name + ".zip" 
        Write-Host $file
        Export-VDSwitch -VDSwitch $vDS -Destination $file -Force | out-null
    }
     Disconnect-VIServer $vc -Confirm:$false   
}
