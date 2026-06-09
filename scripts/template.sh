#!/usr/bin/env sh

PROXY=""
URL="https://cloud-images.ubuntu.com/minimal/releases/noble/release"
IMAGE="ubuntu-24.04-minimal-cloudimg-amd64.img"
QCOW="ubuntu-24.04-minimal-cloudimg-amd64.qcow2"
NAME="ubuntu-2404-tmpl"
ID=5002
MEM=1024
STORAGE="local-lvm"

export http_proxy=$PROXY
export https_proxy=$PROXY
export HTTP_PROXY=$PROXY
export HTTPS_PROXY=$PROXY

if [ -f "$IMAGE" ]; then
    rm $IMAGE
fi

if [ -f "$QCOW" ]; then
    rm $QCOW
fi

wget -O $IMAGE $URL/$IMAGE

qm list | grep $ID

if [ $? -eq 0 ]; then
    echo "The VM $ID already exists"
    qm destroy $ID
fi

qm create $ID --name $NAME --agent 1 --memory $MEM

cp $IMAGE $QCOW

qm importdisk $ID $QCOW $STORAGE

qm set $ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$ID-disk-0

qm set $ID --tags Template

qm set $ID --ide2 $STORAGE:cloudinit

qm set $ID --boot c --bootdisk scsi0

qm set $ID --serial0 socket --vga std

qm template $ID
