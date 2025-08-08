variable "naming_suffix" {
  description = "Resources naming suffix used by naming module"
  type        = list(string)
  default     = ["mra"]
}

variable "location_cidr_list" {
  type = list(object({
    location = string,
    cidr     = list(string)
  }))
  default = [
    { location = "southeastasia", cidr = ["10.255.240.0/20"] },
    # { location = "westeurope", cidr = ["10.255.224.0/20"] },
    # { location = "eastus2", cidr = ["10.255.208.0/20"] },
  ]
}
