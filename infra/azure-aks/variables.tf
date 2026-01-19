variable "aks_name" {
  description = "name of the AKS instance"
  type        = string
}

variable "aks_location" {
  description = "datacenter location of the AKS instance"
  type        = string
}

variable "resource_group_name" {
  description = "name of the corresponding resource group"
  type        = string
}

variable "subnet_id" {
  description = "id of the subnet containing all AKS nodes"
  type        = string
}

variable "authorized_ip_ranges" {
  description = "the authorized ip ranges from which developers can administrate"
  type        = set(string)
}
