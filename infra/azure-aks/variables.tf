variable "ask_name" {
  type = string
}

variable "ask_location" {
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
