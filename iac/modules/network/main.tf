data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = [var.app_subnet_address_prefix]
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = var.private_endpoint_subnet_name
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = [var.private_endpoint_subnet_address_prefix]

  private_endpoint_network_policies = "Disabled"
}