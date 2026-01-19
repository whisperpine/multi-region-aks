# --------- #
# variables
# --------- #

output "location_list" {
  value       = [for o in var.location_cidr_list : o.location]
  description = "the list of all datacenter locations"
}
output "main_location" {
  value       = var.location_cidr_list[0].location
  description = "the main location used by CosmosDB"
}

# ------------- #
# module.naming
# ------------- #

output "resource_group_name_prefix" {
  value       = module.naming.resource_group.name
  description = "the name prefix of resource groups"
}

output "kubernetes_cluster_name_prefix" {
  value       = module.naming.kubernetes_cluster.name
  description = "the name prefix of AKS clusters"
}

# ----------- #
# module.root
# ----------- #

output "resource_group_name" {
  value       = [for o in azurerm_resource_group.default : o.name]
  description = "the name list of resource groups"
}

# ----------------- #
# module.azure_vnet
# ----------------- #

output "vnet_name" {
  value       = [for o in module.azure_vnet : o.vnet_name]
  description = "the name list of vnets"
}

# ---------------- #
# module.azure_aks
# ---------------- #

output "kubernetes_cluster_name" {
  value       = [for o in module.azure_aks : o.kubernetes_cluster_name]
  description = "the name list of AKS clusters"
}

# --------------------- #
# module.azure_cosmosdb
# --------------------- #

output "cosmosdb_account_name" {
  value       = module.azure_cosmosdb.cosmosdb_account_name
  description = "the account name of CosmosDB"
}
