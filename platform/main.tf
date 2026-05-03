####################################################################################
## C L U S T E R S
####################################################################################

module "south" {
  source      = "./modules/kube"
  area        = "south"
  masters     = var.masters
  workers     = var.workers
  nbmasters   = 1
  nbworkers   = 1
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  vlan        = 200
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "debian-13-tmpl"
  size        = 30
  storage     = var.storage
  store       = "64"
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
}

####################################################################################
## H L S
####################################################################################

module "hls" {
  source      = "./modules/hls"
  name        = "hls-server"
  area        = "south"
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  octet       = "54"
  vlan        = 200
  memory      = 4096
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-150-tmpl"
  size        = 30
  storage     = var.storage
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
  adminip     = "10.9.0.30"
}

####################################################################################
## N F S  S T O R A G E
####################################################################################

module "storage" {
  source      = "./modules/storage"
  name        = "nfs-server"
  area        = "south"
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  octet       = "64"
  vlan        = 200
  memory      = 4096
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-150-tmpl"
  size        = 30
  storage     = var.storage
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
  adminip     = "10.9.0.30"
}

####################################################################################
## D E V
####################################################################################

module "dev" {
  source      = "./modules/dev"
  area        = "south"
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  octet       = "44"
  jail        = "45"
  vlan        = 200
  memory      = 4096
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-150-tmpl"
  size        = 30
  storage     = var.storage
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
}

####################################################################################
## O U T P U T
####################################################################################

output "master_south_ip_address" {
  description = "South Masters IP Address"
  value       = module.south
}

output "hls_server_ip_address" {
  description = "Hls Server IP Address"
  value       = module.hls
}

output "dev_server_ip_address" {
  description = "Dev Server IP Address"
  value       = module.dev
}

output "storage_server_ip_address" {
  description = "Storage Server IP Address"
  value       = module.storage
}
