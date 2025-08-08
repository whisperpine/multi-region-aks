variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "vnet_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "security_group_name" {
  type = string
}
