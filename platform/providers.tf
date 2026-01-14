terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.fqdn_pmox
  pm_api_token_id     = var.token_id
  pm_api_token_secret = var.token
  pm_tls_insecure     = true
}
