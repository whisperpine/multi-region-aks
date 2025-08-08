output "vnet_location" {
  value = azurerm_virtual_network.default.location
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "subnet_id" {
  value = azurerm_subnet.default.id
}
