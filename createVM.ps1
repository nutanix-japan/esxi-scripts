

#
# PowerCLI to create VMs from existing vSphere VM
# Version 1.0
#
# Specify vCenter Server, vCenter Server username and vCenter Server user password
$vCenter=""
$vCenterUser="administrator@vsphere.local"
$vCenterUserPassword=""
#
# Specify number of VMs you want to create
$vm_count = "65"
#
# Specify the VM you want to clone
$clone = "Windows2016"
#
#
# Specify the datastore or datastore cluster placement
$ds = "vmContainer1"
#
# Specify the vSphere Cluster
$Cluster = "Cluster1"
#
# Specify the VM name to the left of the - sign
$VM_prefix = "user"
#
# End of user input parameters
#_______________________________________________________
#
write-host "Connecting to vCenter Server $vCenter" -foreground green
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore
Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
1..$vm_count | foreach {
$y="{0:D1}" -f + $_
$VM_name= $y + "_User_Source_VM"
$ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | Get-Random
write-host "Creation of VM $VM_name initiated on $ESXi" -foreground green
New-VM -Name $VM_Name -VM $clone -VMHost $ESXi -Datastore $ds -Location $Folder -RunAsync
}

# Power-on sequence

56..65 | foreach {
    $y="{0:D1}" -f + $_
    $VM_name= $y + "_User_Source_VM"
    write-host "Powering on VM $VM_name" -foreground green
    Start-VM -VM $VM_Name
    }


# Power-off sequence

1..5 | foreach {
    $y="{0:D1}" -f + $_
    $VM_name= $y + "_User_Source_VM"
    write-host "Powering off VM $VM_name initiated" -foreground green
    stop-vm -VM $VM_Name -Confirm:$false
    }

# Delete VM Sequence

1..5 | foreach {
    $y="{0:D1}" -f + $_
    $VM_name= $y + "_User_Source_VM"
    write-host "Deleting VM $VM_name initiated on $ESXi host " -foreground green
    Remove-VM -VM $VM_Name -DeletePermanently -Confirm:$false
    }

# Iteration sequence

6..65 | foreach {
$y="{0:D1}" -f + $_
$VM_name= $y + "_User_Source_VM"
write-host "Powering on VM $VM_name initiated" -foreground green
}

# Disconnect
Disconnect-VIServer -Confirm:$false


# Install-Module -Name VMware.PowerCLI
# Add-PSSnapin "VMware.VimAutomation.Core"

# $p = [Environment]::GetEnvironmentVariable("PSModulePath")
# $p += ";C:Program Files (x86)VMwareInfrastructurevSphere PowerCLIModules"
# [Environment]::SetEnvironmentVariable("PSModulePath",$p)


# Find-Module -Name VMware.PowerCLI
# Install-Module -Name VMware.PowerCLI -Scope CurrentUser
# Get-Command -Module *VMWare*


# $PSVersionTable

# Set-ExecutionPolicy RemoteSigned -Force


#Get-vm host
#Get-VMHost -Name 10.42.50.26 | get-vm
#get-cluster Cluster1  | get-vm | where {$_.PowerState -eq "PoweredOn"}
