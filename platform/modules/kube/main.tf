####################################################################################
##  RESOURCES
####################################################################################

resource "proxmox_vm_qemu" "master_server" {
  count       = var.nbmasters
  description = "Deploiement VM Ubuntu master on Proxmox"
  name        = "${var.area}-${var.masters[count.index].name}"
  target_node = var.target_node
  clone       = var.clone

  os_type  = "cloud-init"
  memory   = var.masters[count.index].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent    = 1

  cpu {
    type    = "host"
    cores   = var.masters[count.index].cores
    sockets = var.masters[count.index].sockets
  }

  tags = "Faye;K3s"

  cicustom = "user=${var.cloudinit}:snippets/cloudinit.yaml"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.size
          storage = var.storage
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan
  }

  ipconfig0  = "ip=${var.prefix}.${var.masters[count.index].octet}/24,gw=${var.prefix}.1"
  nameserver = var.nameserver


  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo hostnamectl set-hostname ${var.area}-${var.masters[count.index].name}"
    ]

    connection {
      host        = "${var.prefix}.${var.masters[count.index].octet}"
      type        = "ssh"
      user        = var.userctn
      private_key = file(var.privkeyctn)
    }
  }
}

resource "proxmox_vm_qemu" "worker_server" {
  count       = var.nbworkers
  description = "Deploiement VM Ubuntu worker on Proxmox"
  name        = "${var.area}-${var.workers[count.index].name}"
  target_node = var.target_node
  clone       = var.clone

  os_type  = "cloud-init"
  memory   = var.workers[count.index].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent    = 1

  cpu {
    type    = "host"
    cores   = var.workers[count.index].cores
    sockets = var.workers[count.index].sockets
  }

  tags = "Faye;K3s"

  cicustom = "user=${var.cloudinit}:snippets/cloudinit.yaml"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.size
          storage = var.storage
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan
  }

  ipconfig0  = "ip=${var.prefix}.${var.workers[count.index].octet}/24,gw=${var.prefix}.1"
  nameserver = var.nameserver


  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo hostnamectl set-hostname ${var.area}-${var.workers[count.index].name}"
    ]

    connection {
      host        = "${var.prefix}.${var.workers[count.index].octet}"
      type        = "ssh"
      user        = var.userctn
      private_key = file(var.privkeyctn)
    }
  }
}

####################################################################################
##  ANSIBLE
####################################################################################

resource "local_file" "inventory" {
  content = templatefile("${path.module}/manifests/inventory-template.yaml",
    {
      masters    = proxmox_vm_qemu.master_server[*]
      workers    = proxmox_vm_qemu.worker_server[*]
      userctn    = var.userctn
      privkeyctn = var.privkeyctn
  })
  filename        = "./ansible/inventory-k3s.yaml"
  file_permission = "0644"
}

resource "local_file" "playbook" {
  content = templatefile("${path.module}/manifests/playbook-template.yaml",
    {
      proxy                     = var.proxy
      noproxy                   = "10.233.64.0/18,10.233.0.0/18,${var.prefix}.0/24"
      kubeadm_init_master       = proxmox_vm_qemu.master_server[0].name
      advertise_address         = "${var.prefix}.${var.masters[0].octet}"
      kubeadm_master_group_name = "master_nodes"
      kubeadm_worker_group_name = "worker_nodes"
      prefix                    = var.prefix
      area                      = var.area
  })
  filename        = "./ansible/playbook-k3s.yaml"
  file_permission = "0644"
}

resource "null_resource" "play_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory-k3s.yaml ansible/playbook-k3s.yaml"
  }
  depends_on = [
    proxmox_vm_qemu.master_server,
    proxmox_vm_qemu.worker_server,
    local_file.inventory,
    local_file.playbook
  ]
}


####################################################################################
##  OUTPUT
####################################################################################

output "masters_ip_address" {
  description = "Masters IP Address"
  value       = proxmox_vm_qemu.master_server[*].default_ipv4_address
}

output "workers_ip_address" {
  description = "Workers IP Address"
  value       = proxmox_vm_qemu.worker_server[*].default_ipv4_address
}
