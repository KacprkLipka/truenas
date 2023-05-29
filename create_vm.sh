#!/bin/sh
# Create Virtual Machine using VirtualBox
# Kacper Lipka 2023

alias vbm="VBoxManage"
vm_name="TrueNAS"
os_name="Other_64"
iso_path="/home/kacper/Desktop/Projekt/TrueNAS-SCALE-22.12.2.iso"
medium_path="/home/kacper/Desktop/Projekt/VirtualBox"
storage="10000"
memory="10000"
bridge="wlp3s0"

vbm createvm --name $vm_name --ostype $os_name --register

vbm storagectl $vm_name --name "SATA Controller" --add sata --controller IntelAHCI

for i in 1 2 3; do
    vbm createhd --filename $medium_path$vm_name'/'$vm_name'_'$i.vdi --size $storage --format VDI

    vbm storageattach $vm_name --storagectl "SATA Controller" --port $i --device 0 --type hdd --medium $medium_path$vm_name'/'$vm_name'_'$i.vdi
done

vbm storagectl $vm_name --name "IDE Controller" --add ide

vbm storageattach $vm_name --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $iso_path

vbm modifyvm $vm_name --memory $memory --vram 128
vbm modifyvm $vm_name --nic1 bridged --bridgeadapter1 $bridge

vbm startvm $vm_name
