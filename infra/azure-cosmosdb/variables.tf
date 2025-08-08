variable "resource_group_name" {
  type = string
}

variable "cosmosdb_name" {
  type = string
}

variable "cosmosdb_location" {
  type = string
}

variable "throughput_limit" {
  type = string
  validation {
    condition     = var.throughput_limit % 100 == 0 && var.throughput_limit >= 400
    error_message = "throughput_limit must be set in increments of 100. The minimum value is 400"
  }
}

variable "location_list" {
  type = list(string)
}

variable "subnet_id_list" {
  type = list(string)
}

variable "free_tier_enabled" {
  type = bool
}
