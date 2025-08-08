terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "default" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.vnet_location
  resource_group_name = var.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  # Don't overlap with the default CIDR of AKS, which is "10.0.0.0/16".
  # Here the address space of vnet is directly assigned to the subnet,
  # cause I decide to split only one subnet in the vnet.
  address_prefixes = var.address_space
  # service_endpoints is required before binding subnet to a resource.
  service_endpoints = ["Microsoft.AzureCosmosDB"]
  # It has to be "Disabled" if private endpoint will be added to the subnet.
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "default" {
  name                = var.security_group_name
  location            = var.vnet_location
  resource_group_name = var.resource_group_name
}
