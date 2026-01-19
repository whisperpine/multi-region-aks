variable "resource_group_name" {
  description = "name of the resource group"
  type        = string
}

variable "cosmosdb_name" {
  description = "name of the CosmosDB instance"
  type        = string
}

variable "cosmosdb_location" {
  description = "the main location of the CosmosDB instance"
  type        = string
}

variable "throughput_limit" {
  description = "the throughput limist of CosmosDB"
  type        = string
  validation {
    condition     = var.throughput_limit % 100 == 0 && var.throughput_limit >= 400
    error_message = "throughput_limit must be set in increments of 100. The minimum value is 400"
  }
}

variable "location_list" {
  description = "the list of locations from which CosmosDB can be accessed"
  type        = list(string)
}

variable "subnet_id_list" {
  description = "the list of subnet IDs"
  type        = list(string)
}

variable "free_tier_enabled" {
  description = "if the free tier of CosmosDB is enabled"
  type        = bool
}
