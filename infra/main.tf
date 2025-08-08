# https://registry.terraform.io/modules/Azure/naming/azurerm/latest
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4.2"
  suffix  = var.naming_suffix
}

# https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file
data "sops_file" "default" {
  source_file = "encrypted.${terraform.workspace}.json"
}

locals {
  # provider: hashicorp/azurerm
  # repository      = "multi-region-aks"
  client_id       = data.sops_file.default.data["client_id"]       # string
  client_secret   = data.sops_file.default.data["client_secret"]   # string
  tenant_id       = data.sops_file.default.data["tenant_id"]       # string
  subscription_id = data.sops_file.default.data["subscription_id"] # string
  # "for_each" can only be assigned with a map or set.
  location_set = toset([for o in var.location_cidr_list : o.location]) # set(string)
  # module: azure-aks
  # Find the public IP of your local device by visiting: https://ifconfig.me
  # or run the following command: `curl ifconfig.me`. 
  # Then add an IP range that includes that IP (e.g. "123.123.123.123/32").
  # To allow access from all IP addresses, use this: "0.0.0.0/0" (don't do this in production).
  aks_authorized_ip_ranges = toset([data.sops_file.default.data["aks_authorized_ip_range"]]) # set(string)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "default" {
  # Create multiple instances of this module.
  for_each = local.location_set
  location = each.value
  name     = "${module.naming.resource_group.name}-${each.value}"
}

# Azure Virtual Network (vnet) and subnet.
module "azure_vnet" {
  # Create multiple instances of this module.
  for_each            = { for o in var.location_cidr_list : o.location => o.cidr }
  source              = "./azure-vnet"
  resource_group_name = azurerm_resource_group.default[each.key].name
  vnet_location       = each.key
  address_space       = each.value
  vnet_name           = "${module.naming.virtual_network.name}-${each.key}"
  security_group_name = "${module.naming.network_security_group.name}-${each.key}"
}

# Multi-region Azure Kubernetes Service (AKS).
module "azure_aks" {
  # Create multiple instances of this module.
  for_each             = local.location_set
  source               = "./azure-aks"
  resource_group_name  = azurerm_resource_group.default[each.value].name
  ask_name             = "${module.naming.kubernetes_cluster.name}-${each.value}"
  subnet_id            = module.azure_vnet[each.value].subnet_id
  ask_location         = each.value
  authorized_ip_ranges = local.aks_authorized_ip_ranges
}
