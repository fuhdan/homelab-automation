variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox username (format: user@pam)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_storage" {
  description = "Proxmox storage name"
  type        = string
  default     = "local-lvm"
}

variable "proxmox_bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ubuntu_template" {
  description = "Ubuntu 24.04 cloud-init template name"
  type        = string
  default     = "ubuntu-2404-cloudinit"
}

variable "gateway" {
  description = "Default gateway"
  type        = string
  default     = "192.168.40.1"
}

variable "dns_servers" {
  description = "DNS servers"
  type        = list(string)
  default     = ["192.168.40.10", "192.168.40.11"]
}