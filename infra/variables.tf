variable "naming_suffix" {
  description = "resources naming suffix used by naming module"
  type        = list(string)
  default     = ["mra"]
}

variable "location_cidr_list" {
  description = "list of locations and corresponding cidr ranges"
  type = list(object({
    location = string,
    cidr     = list(string)
  }))
  # Note: The order of elements matters.
  # - The first element is the main location of cosmosdb.
  # - The higher the order, the higher the failover_priority of cosmosdb.
  # - Start from the last one if you want to destroy an element, don't change the order.
  default = [
    { location = "southeastasia", cidr = ["10.255.240.0/20"] },
    # { location = "westeurope", cidr = ["10.255.224.0/20"] },
    # { location = "eastus2", cidr = ["10.255.208.0/20"] },
  ]
}
