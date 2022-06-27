$vCenter = "vc7.vkasaert.local"
#connect-viserver $vcenter

$file=".\extradisk.txt"
$vmlist=Get-Content $file

$log = ".\extradisk.log"
Out-File -filepath $log

foreach ($vm in $vmlist) {
    "Start disk extension on VM: " + $vm | out-file $log -Append 
    $datastore = Get-VM -Name $vm | Get-Datastore
    "VM is located on DS: " + $datastore | out-file $log -Append  
    if ($datastore.length -gt 1) {
        "VM: " + $vm + " has multiple datastores attached => " + $datastore | out-file $log -Append 
        "Skipping VM!!" | out-file $log -Append 
         
    }else{
        $sizeFree = $datastore.FreeSpaceGB - 30
        "Free size minus extra 30GB: " + $sizeFree | out-file $log -Append 
        $sizeTotal = $datastore.CapacityGB
        "Total size: " + $sizeTotal | out-file $log -Append 
        $procentfree = ($sizeFree/$sizeTotal)*100
        "Procent free on DS: " + $datastore + " equals = " + $procentfree | out-file $log -Append 
        if ($procentfree -ge 20){
            # new-harddisk -vm $vm -CapacityGB 30
            "Extra harddisk added to VM: " + $vm | out-file $log -Append 
        }else{
            "Percentage free is less then 20%, skipping disk extension on " + $vm | out-file $log -Append 
        }
    }
    "------------------------------------------------------------------" | out-file $log -Append 
}
