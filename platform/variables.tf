variable "userctn" { default = "spike" }
variable "publkeyctn" {}
variable "privkeyctn" {}
variable "token" {}
variable "token_id" {}
variable "fqdn_pmox" {}
variable "bridge" { default = "vmbr3" }

variable "proxy" { default = "" }
variable "noproxy" { default = "127.0.0.1,localhost,10.0.0.0/8,10.42.0.0/16,10.43.0.0/16" }
variable "nameserver" { default = "192.168.68.1" }

variable "cloudinit" { default = "local" }
variable "target_node" { default = "proxmox" }
variable "storage" { default = "local-lvm" }

variable "prefix" { default = "192.188.200" }
variable "adminip" { default = "10.9.0.30" }

variable "vlan" { default = 200 }

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
      memory  = 8192
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
      memory  = 8192
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


variable "lisp" {
  type = list(object({
    name    = string
    octet   = string
    memory  = number
    cores   = number
    sockets = number
  }))
  default = [
    {
      name    = "frontend"
      octet   = "211"
      memory  = 2048
      cores   = 1
      sockets = 1
      }, {
      name    = "backend"
      octet   = "212"
      memory  = 2048
      cores   = 1
      sockets = 1
    },
    {
      name    = "proxy1"
      octet   = "213"
      memory  = 1024
      cores   = 1
      sockets = 1
      }, {
      name    = "proxy2"
      octet   = "214"
      memory  = 1024
      cores   = 1
      sockets = 1
    },
    {
      name    = "oracle"
      octet   = "215"
      memory  = 1024
      cores   = 1
      sockets = 1
    }
  ]
}
