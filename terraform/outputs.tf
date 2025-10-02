output "vm_details" {
  description = "Details of created VMs"
  value = {
    for k, v in proxmox_virtual_environment_vm.vm : k => {
      name   = v.name
      node   = v.node_name
      cpus   = v.cpu[0].cores
      memory = v.memory[0].dedicated
      ip     = local.servers[index(local.servers.*.name, k)].ip
    }
  }
}