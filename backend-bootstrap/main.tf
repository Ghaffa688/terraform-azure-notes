data "azurerm_virtual_network" "sandbox" {
  name                = "vnet-rg-sandbox-cloud-aly-ghazal"
  resource_group_name = "rg-sandbox-cloud-aly-ghazal"
}

data "azurerm_subnet" "backend" {
  name                 = "snet-default"
  resource_group_name  = "rg-sandbox-cloud-aly-ghazal"
  virtual_network_name = data.azurerm_virtual_network.sandbox.name
}

resource "azurerm_storage_account" "tfstate" {
  name                = "ahmednotes680tfstate"
  resource_group_name = "rg-sandbox-cloud-aly-ghazal"
  location            = "eastus"

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [data.azurerm_subnet.backend.id]
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}