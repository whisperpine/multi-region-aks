#### variables ####
output "location_list" {
  value = [for o in var.location_cidr_list : o.location]
}
output "main_location" {
  value = var.location_cidr_list[0].location
}

#### module.naming ####
output "resource_group_name_prefix" {
  value = module.naming.resource_group.name
}
output "kubernetes_cluster_name_prefix" {
  value = module.naming.kubernetes_cluster.name
}

#### module.root ####
output "resource_group_name" {
  value = [for o in azurerm_resource_group.default : o.name]
}

#### module.azure_vnet ####
output "vnet_name" {
  value = [for o in module.azure_vnet : o.vnet_name]
}

#### module.azure_aks ####
output "kubernetes_cluster_name" {
  value = [for o in module.azure_aks : o.kubernetes_cluster_name]
}
