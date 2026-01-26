####################################################################################
## C L U S T E R S
####################################################################################

# module "south" {
#   source      = "./modules/kube"
#   area        = "south"
#   masters     = var.masters
#   workers     = var.workers
#   nbmasters   = 1
#   nbworkers   = 1
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   vlan        = 200
#   nameserver  = var.nameserver
#   target_node = var.target_node
#   clone       = "ubuntu-2404-tmpl"
#   size        = 30
#   storage     = var.storage
#   cloudinit   = var.cloudinit
#   proxy       = var.proxy
#   userctn     = var.userctn
#   publkeyctn  = var.publkeyctn
#   privkeyctn  = var.privkeyctn
# }

####################################################################################
## H L S
####################################################################################

module "hls" {
  source      = "./modules/hls"
  area        = "south"
  prefix      = "192.188.200" # VLAN 200
  bridge      = var.bridge
  octet       = "55"
  vlan        = 200
  memory      = 2048
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-143-tmpl"
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

# output "master_south_ip_address" {
#   description = "South Masters IP Address"
#   value       = module.south
# }

output "hls_server_ip_address" {
  description = "Hls Server IP Address"
  value       = module.hls
}
