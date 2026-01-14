variable "userctn" { default = "spike" }
variable "publkeyctn" { default = "~/.ssh/id_ed25519_proxmox.pub" }
variable "privkeyctn" { default = "~/.ssh/id_ed25519_proxmox" }
variable "token" {}
variable "token_id" {}
variable "fqdn_pmox" {}
variable "bridge" { default = "vmbr3" }

# variable "proxy" { default = "http://proxy.rd.francetelecom.fr:8080" }
variable "proxy" { default = "" }
# variable "nameserver" { default = "10.192.65.254" }
variable "nameserver" { default = "192.168.68.1" }

variable "cloudinit" { default = "local" }
variable "target_node" { default = "proxmox" }
variable "storage" { default = "local-lvm" }

variable "masters" {
  type = list(object({
    name    = string
    octet   = string
    memory  = number
    cores   = number
    sockets = number
  }))
  default = [
    {
      name    = "master1"
      octet   = "101"
      memory  = 5120
      cores   = 2
      sockets = 1
      }, {
      name    = "master2"
      octet   = "102"
      memory  = 4096
      cores   = 2
      sockets = 1
      }, {
      name    = "master3"
      octet   = "103"
      memory  = 4096
      cores   = 2
      sockets = 1
    }
  ]
}

variable "workers" {
  type = list(object({
    name    = string
    octet   = string
    memory  = number
    cores   = number
    sockets = number
  }))
  default = [
    {
      name    = "worker1"
      octet   = "111"
      memory  = 5120
      cores   = 2
      sockets = 1
      }, {
      name    = "worker2"
      octet   = "112"
      memory  = 4096
      cores   = 2
      sockets = 1
      }, {
      name    = "worker3"
      octet   = "113"
      memory  = 4096
      cores   = 2
      sockets = 1
    }
  ]
}
