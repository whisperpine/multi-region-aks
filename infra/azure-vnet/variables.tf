variable "vnet_name" {
  description = "the name of the vnet"
  type        = string
}

variable "address_space" {
  description = "a list CDIR address space"
  type        = list(string)
}

variable "vnet_location" {
  description = "the datacenter location in which the vnet located"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group"
  type        = string
}

variable "security_group_name" {
  description = "name of the default security group"
  type        = string
}
