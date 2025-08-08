terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

# ASK (Azure Kubernetes Service) docs: 
# https://learn.microsoft.com/en-us/azure/aks/
# Example projects on GitHub:
# https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/kubernetes
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
resource "azurerm_kubernetes_cluster" "default" {
  name                = var.ask_name
  location            = var.ask_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.ask_name
  sku_tier            = "Free"

  kubernetes_version = "1.33.2"
  # Options: patch, rapid, node-image, stable
  automatic_upgrade_channel = "patch"

  role_based_access_control_enabled = true

  # System node pool.
  default_node_pool {
    name            = "default"
    vm_size         = "Standard_D2ps_v6"
    os_disk_size_gb = 32
    os_disk_type    = "Managed"
    vnet_subnet_id  = var.subnet_id
    node_count      = 1
    upgrade_settings {
      max_surge = "20%"
    }
    # Note: "system nodes" aren't "master nodes" in kubernetes (which is relevant to "worker nodes").
    # "system nodes" and "user nodes" in AKS are both "worker nodes" in the concept of kubernetes.
    # "system nodes" are responsible for k8s services like CoreDNS, and can also be used to deploy custom services.
    # The default k8s node label of "system nodes" is "kubernetes.azure.com/mode=system".
    # The "master nodes" of a kubernetes cluster is managed by AKS which are invisible.
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet" # Options: azure, kubenet, none
    network_policy = "calico"  # Options: calico, azure, cilium
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  # If set to true, the kubernetes cluster cannot be operated by kubectl. Refer to:
  # https://learn.microsoft.com/en-us/azure/aks/access-private-cluster
  # private_cluster_enabled = true
}

# Regular instances are expensive but stable, suitable for services that aren't allowed to stop unexpectedly.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
resource "azurerm_kubernetes_cluster_node_pool" "regular" {
  name    = "regular"
  vm_size = "Standard_D2ps_v6"

  vnet_subnet_id        = var.subnet_id
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id

  # Note: the max count is also limited by quota.
  max_count            = 5
  min_count            = 0
  auto_scaling_enabled = true

  os_disk_type    = "Managed" # Options: "Managed" or "Ephemeral"
  os_disk_size_gb = 32

  upgrade_settings {
    max_surge = "20%"
  }
}

# Spot instances are much cheaper compared to regular instances (e.g. with a minimum of 10% costs).
# The downside is that spot instances can be evicted unexpectedly (the eviction rate is typically 0-5%).
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name    = "spot"
  vm_size = "Standard_D2ps_v6"

  vnet_subnet_id        = var.subnet_id
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id

  # Note: the max count is also limited by quota.
  max_count            = 15
  min_count            = 0
  auto_scaling_enabled = true

  priority        = "Spot" # Options: "Regular", "Spot"
  eviction_policy = "Delete"
  os_disk_type    = "Managed"
  os_disk_size_gb = 32

  # Pods allowed to stop unexpectedly should be inclined to be scheduled on spot instances.
  # "node.metadata.labels" is relevant to "pod.spec.affinity".
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  # Pods not allowed to stop unexpectedly mustn't be scheduled on spot instances.
  # "node.spec.taints" is relevant to "pod.spec.tolerations".
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
}
