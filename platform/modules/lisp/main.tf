####################################################################################
##  RESOURCES
####################################################################################

resource "proxmox_vm_qemu" "lisp_server" {
  count       = length(var.lisp)
  description = "Deploiement VM Ubuntu lisp on Proxmox"
  name        = "${var.area}-${var.lisp[count.index].name}"
  target_node = var.target_node
  clone       = var.clone

  os_type  = "cloud-init"
  memory   = var.lisp[count.index].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent    = 1

  cpu {
    type    = "host"
    cores   = var.lisp[count.index].cores
    sockets = var.lisp[count.index].sockets
  }

  tags = "Linux;Lisp"

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

  ipconfig0  = "ip=${var.prefix}.${var.lisp[count.index].octet}/24,gw=${var.prefix}.1"
  nameserver = var.nameserver


  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo hostnamectl set-hostname ${var.area}-${var.lisp[count.index].name}"
    ]

    connection {
      host        = "${var.prefix}.${var.lisp[count.index].octet}"
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
      lisp       = proxmox_vm_qemu.lisp_server[*]
      userctn    = var.userctn
      privkeyctn = var.privkeyctn
  })
  filename        = "./ansible/inventory-lisp.yaml"
  file_permission = "0644"
}

resource "local_file" "playbook" {
  content = templatefile("${path.module}/manifests/playbook-template.yaml",
    {
      proxy   = var.proxy
      noproxy = "10.233.64.0/18,10.233.0.0/18,${var.prefix}.0/24"
      prefix  = var.prefix
      area    = var.area
  })
  filename        = "./ansible/playbook-lisp.yaml"
  file_permission = "0644"
}

resource "null_resource" "play_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory-lisp.yaml ansible/playbook-lisp.yaml"
  }
  depends_on = [
    proxmox_vm_qemu.lisp_server,
    local_file.inventory,
    local_file.playbook
  ]
}


####################################################################################
##  OUTPUT
####################################################################################

output "lisp_ip_address" {
  description = "Lisp IP Address"
  value       = proxmox_vm_qemu.lisp_server[*].default_ipv4_address
}
