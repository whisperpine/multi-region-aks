variable "aks_name" {
  type = string
}

variable "aks_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "authorized_ip_ranges" {
  type = set(string)
}
