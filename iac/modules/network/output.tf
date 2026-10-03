output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoint.id
}