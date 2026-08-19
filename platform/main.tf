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
  vlan        = var.vlan
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "ubuntu-2404-tmpl"
  size        = 30
  storage     = var.storage
  store       = "64"
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  noproxy     = var.noproxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
  depends_on  = [module.storage]
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
  vlan        = var.vlan
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
  adminip     = var.adminip
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
  vlan        = var.vlan
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
  adminip     = var.adminip
}

####################################################################################
## P R I V A T E   R E G I S T R Y
####################################################################################

module "registry" {
  source      = "./modules/registry"
  name        = "registry-server"
  area        = "south"
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  octet       = "67"
  vlan        = var.vlan
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
  adminip     = var.adminip
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

output "storage_server_ip_address" {
  description = "Storage Server IP Address"
  value       = module.storage
}

output "registry_server_ip_address" {
  description = "Registry Server IP Address"
  value       = module.registry
}
