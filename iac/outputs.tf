output "resource_group_name" {
  value = module.network.resource_group_name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "app_subnet_id" {
  value = module.network.app_subnet_id
}

output "private_endpoint_subnet_id" {
  value = module.network.private_endpoint_subnet_id
}
output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_account_id" {
  value = module.storage.storage_account_id
}
output "webapp_name" {
  value = module.webapp.webapp_name
}

output "webapp_url" {
  value = module.webapp.webapp_url
}
output "identity_id" {
  value = module.identity.identity_id
}

output "identity_principal_id" {
  value = module.identity.principal_id
}
output "keyvault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "keyvault_id" {
  value = azurerm_key_vault.main.id
}