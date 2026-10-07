output "resource_group_name" {
  value = data.azurerm_resource_group.existing.name
}

output "vnet_name" {
  value = data.azurerm_virtual_network.existing.name
}

output "app_subnet_id" {
  value = data.azurerm_subnet.app.id
}

output "private_endpoint_subnet_id" {
  value = data.azurerm_subnet.private_endpoint.id
}