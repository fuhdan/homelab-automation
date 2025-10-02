output "vm_details" {
  description = "Details of created VMs"
  value = {
    for k, v in proxmox_vm_qemu.vm : k => {
      name         = v.name
      node         = v.target_node
      cpus         = v.cores
      memory       = v.memory
      ip           = local.servers[index(local.servers.*.name, k)].ip
    }
  }
}