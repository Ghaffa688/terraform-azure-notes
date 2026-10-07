variable "owner" {
  description = "Resource owner"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "stage"], var.environment)
    error_message = "Environment must be dev or stage."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "costcenter" {
  description = "Cost center"
  type        = string
}

variable "webapp_count" {
  description = "Number of web apps"
  type        = number
}
variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}
variable "resource_group_name" {
  description = "Existing sandbox resource group"
  type        = string
}

variable "vnet_name" {
  description = "Existing sandbox virtual network"
  type        = string
}

variable "app_subnet_address_prefix" {
  description = "Application subnet CIDR"
  type        = string
}

variable "private_endpoint_subnet_address_prefix" {
  description = "Private endpoint subnet CIDR"
  type        = string
}