terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

locals {
  servers       = yamldecode(file("${path.module}/servers.yaml")).servers
  proxmox_nodes = yamldecode(file("${path.module}/proxmox-nodes.yaml")).proxmox_nodes
  os_templates  = yamldecode(file("${path.module}/os-templates.yaml")).os_templates
}

resource "proxmox_vm_qemu" "vm" {
  for_each = { for server in local.servers : server.name => server }

  name        = each.value.name
  target_node = local.proxmox_nodes[each.value.node].hostname
  clone       = local.os_templates[each.value.os].template_name
  full_clone  = true

  cores   = each.value.vcpu
  sockets = 1
  memory  = each.value.memory
  
  agent = 1

  disks {
    scsi {
      scsi0 {
        disk {
          size    = each.value.disk / 1024
          storage = var.proxmox_storage
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = var.proxmox_bridge
  }

  ipconfig0 = "ip=${each.value.ip}/24,gw=${var.gateway}"
  
  nameserver = join(" ", var.dns_servers)
  
  os_type = local.os_templates[each.value.os].os_type
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}