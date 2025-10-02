terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  username = var.proxmox_user
  password = var.proxmox_password
  insecure = true
}

locals {
  servers       = yamldecode(file("${path.module}/servers.yaml")).servers
  proxmox_nodes = yamldecode(file("${path.module}/proxmox-nodes.yaml")).proxmox_nodes
  os_templates  = yamldecode(file("${path.module}/os-templates.yaml")).os_templates
}

data "proxmox_virtual_environment_vms" "templates" {
  for_each  = local.os_templates
  node_name = var.template_node
  
  filter {
    name   = "name"
    values = [each.value.template_name]
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = { for server in local.servers : server.name => server }

  name        = each.value.name
  node_name   = local.proxmox_nodes[each.value.node].hostname

  clone {
    vm_id = data.proxmox_virtual_environment_vms.templates[each.value.os].vms[0].vm_id
    full  = true
  }

  cpu {
    cores = each.value.vcpu
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.proxmox_storage
    size         = each.value.disk / 1024
    interface    = "scsi0"
  }

  network_device {
    bridge = var.proxmox_bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = var.gateway
      }
    }
    
    dns {
      servers = var.dns_servers
    }
  }

  agent {
    enabled = true
  }
}