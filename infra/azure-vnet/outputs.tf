output "vnet_location" {
  description = "the datacenter location of the vnet"
  value       = azurerm_virtual_network.default.location
}

output "vnet_name" {
  description = "name of the vnet"
  value       = azurerm_virtual_network.default.name
}

output "vnet_id" {
  description = "id of the vnet"
  value       = azurerm_virtual_network.default.id
}

output "subnet_id" {
  description = "id of the subnet"
  value       = azurerm_subnet.default.id
}
