variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "app_subnet_name" {
  type = string
}

variable "private_endpoint_subnet_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
