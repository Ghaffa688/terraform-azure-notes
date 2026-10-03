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