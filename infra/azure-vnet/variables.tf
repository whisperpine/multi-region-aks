variable "vnet_name" {
  description = "the name of the vnet"
  type        = string
}

variable "address_space" {
  description = "a list CDIR address space"
  type        = list(string)
  validation {
    condition = alltrue([
      for o in var.address_space :
      can(cidrhost(o, 0))
    ])
    error_message = "invalid CIDR was found"
  }
}

variable "vnet_location" {
  description = "the datacenter location in which the vnet located"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.vnet_location))
    error_message = "location must only be composed of lowercase letters and numbers"
  }
}

variable "resource_group_name" {
  description = "name of the resource group"
  type        = string
}

variable "security_group_name" {
  description = "name of the default security group"
  type        = string
}
