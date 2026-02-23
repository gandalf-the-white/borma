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
  prefix      = "192.188.200" # VLAN 200
  bridge      = var.bridge
  vlan        = 200
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "ubuntu-2404-tmpl"
  size        = 30
  storage     = var.storage
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
  area        = "south"
  prefix      = "192.188.200" # VLAN 200
  bridge      = var.bridge
  octet       = "55"
  vlan        = 200
  memory      = 4096
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
## L I S P 
####################################################################################

module "lisp" {
  source      = "./modules/lisp"
  area        = "north"
  lisp        = var.lisp
  nbmasters   = 1
  nbworkers   = 1
  prefix      = "192.188.200" # VLAN 200
  bridge      = var.bridge
  vlan        = 200
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "ubuntu-2404-tmpl"
  size        = 30
  storage     = var.storage
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
}


####################################################################################
## F R O N T E N D
####################################################################################

# module "frontend" {
#   source      = "./modules/frontend/"
#   name        = "frontend"
#   area        = "south"
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   octet       = "56"
#   vlan        = 200
#   memory      = 2048
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
## B A C K E N D
####################################################################################

# module "backend" {
#   source      = "./modules/backend"
#   name        = "backend"
#   area        = "south"
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   octet       = "57"
#   vlan        = 200
#   memory      = 2048
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
## P R O X Y   P 1
####################################################################################

# module "proxyp1" {
#   source      = "./modules/oracle"
#   name        = "proxyp1"
#   area        = "south"
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   octet       = "60"
#   vlan        = 200
#   memory      = 2048
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
## P R O X Y   P 2
####################################################################################

# module "proxyp2" {
#   source      = "./modules/oracle"
#   name        = "proxyp2"
#   area        = "south"
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   octet       = "61"
#   vlan        = 200
#   memory      = 2048
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
## O R A C L E
####################################################################################

# module "oracle" {
#   source      = "./modules/oracle"
#   name        = "oracle"
#   area        = "south"
#   prefix      = "192.188.200" # VLAN 200
#   bridge      = var.bridge
#   octet       = "58"
#   vlan        = 200
#   memory      = 2048
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

# output "frontend_server_ip_address" {
#   description = "Frontend Server IP Address"
#   value       = module.frontend
# }

# output "backend_server_ip_address" {
#   description = "Backend Server IP Address"
#   value       = module.backend
# }

# output "oracle_server_ip_address" {
#   description = "Oracle Server IP Address"
#   value       = module.oracle
# }
