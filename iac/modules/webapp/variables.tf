variable "app_service_plan_name" {
  type = string
}

variable "webapp_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "identity_id" {
  type = string
}
variable "webapp_count" {
  type = number
}