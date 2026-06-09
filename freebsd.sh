#!/usr/bin/env sh

PROXY=""
COMPRESS="http://ftp.fr.freebsd.org/pub/FreeBSD/releases/VM-IMAGES/14.3-RELEASE/amd64/Latest/FreeBSD-14.3-RELEASE-amd6
4-ufs.qcow2.xz"
QCOW="FreeBSD-14.3-STABLE-amd64-BASIC-CLOUDINIT-ufs.qcow2"
NAME="freebsd-143"
STORAGE="local-lvm"
ID=5012
MEM=1024

export http_proxy=$PROXY
export https_proxy=$PROXY
export HTTP_PROXY=$PROXY
export HTTPS_PROXY=$PROXY

if [ -f "$QCOW" ]; then
    rm $QCOW
fi

wget -qO - $COMPRESS | unxz >$QCOW

qm list | grep $ID

if [ $? -eq 0 ]; then
    echo "The VM $ID already exists"
    qm destroy $ID
fi

qm create $ID --name $NAME --agent 1 --memory $MEM

qm importdisk $ID $QCOW $STORAGE

qm set $ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$ID-disk-0

qm set $ID --tags Template

qm set $ID --boot c --bootdisk scsi0

qm set $ID --serial0 socket --vga std

qm template $ID
