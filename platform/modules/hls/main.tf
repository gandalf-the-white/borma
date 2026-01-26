####################################################################################
##  RESOURCES
####################################################################################

resource "proxmox_vm_qemu" "server" {
  description = "Deploiement VM Ubuntu on Proxmox"
  name        = "${var.area}-server"
  target_node = var.target_node
  clone       = var.clone

  os_type  = "cloud-init"
  memory   = var.memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent    = 1

  cpu {
    type    = "host"
    cores   = 1
    sockets = 1
  }

  tags = "Bsd;Hls"

  cicustom = "user=${var.cloudinit}:snippets/cloudinitbsd.yaml"

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

  ipconfig0  = "ip=${var.prefix}.${var.octet}/24,gw=${var.prefix}.1"
  nameserver = var.nameserver

  provisioner "remote-exec" {
    inline = ["echo 'Wait until ssh is ready'"]

    connection {
      host        = "${var.prefix}.${var.octet}"
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
      ipaddress  = "${var.prefix}.${var.octet}"
      userctn    = var.userctn
      privkeyctn = var.privkeyctn
      name       = "${var.area}-hls"
  })
  filename        = "./ansible/inventory-hls.yaml"
  file_permission = "0644"
}


resource "local_file" "playbook" {
  content = templatefile("${path.module}/manifests/playbook-template.yaml",
    {
      proxy   = var.proxy
      noproxy = "${var.prefix}.0/24"
  })
  filename        = "./ansible/playbook-hls.yaml"
  file_permission = "0644"
}

resource "null_resource" "play_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory-hls.yaml ansible/playbook-hls.yaml"
  }
  depends_on = [
    proxmox_vm_qemu.server,
    local_file.inventory,
    local_file.playbook
  ]
}

####################################################################################
##  OUTPUT
####################################################################################

output "hls_server_ip_address" {
  description = "HLS IP Address"
  value       = proxmox_vm_qemu.server.default_ipv4_address
}
