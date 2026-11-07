
# Resource Group Name
output "resource_group_name" {
  description = "Azure Resource Group Name"
  value       = azurerm_resource_group.rg.name
}

# Virtual Network ID
output "virtual_network_id" {
  description = "Azure Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

# Web Tier Public IP
output "web_public_ip" {
  description = "Public IP of Web VM"
  value       = azurerm_public_ip.web.ip_address
}

# Private IP Addresses
output "vm_private_ips" {
  description = "Private IP addresses of all VMs"

  value = {
    for tier, vm in azurerm_linux_virtual_machine.vm :
    tier => vm.private_ip_address
  }
}

# VM Names
output "vm_names" {
  description = "Names of all three Virtual Machines"

  value = {
    for tier, vm in azurerm_linux_virtual_machine.vm :
    tier => vm.name
  }
}

# Subnet IDs
output "subnet_ids" {
  description = "Subnet IDs for Web, App and Database"

  value = {
    for tier, subnet in azurerm_subnet.subnets :
    tier => subnet.id
  }
}
