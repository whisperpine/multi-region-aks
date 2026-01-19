output "kubernetes_cluster_name" {
  description = "the name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.default.name
}
