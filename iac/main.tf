locals {
  prefix = "${var.owner}-notes-${var.environment}"

  common_tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
    costcenter  = var.costcenter
    managed_by  = "terraform"
  }
}

module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name
  vnet_name           = var.vnet_name
}

module "storage" {
  source = "./modules/storage"

  storage_account_name = replace("${local.prefix}storage", "-", "")
  resource_group_name  = module.network.resource_group_name
  location             = var.location

  subnet_id = module.network.private_endpoint_subnet_id

  tags = local.common_tags
}
resource "azurerm_user_assigned_identity" "identity" {
  name                = "${local.prefix}-identity"
  resource_group_name = module.network.resource_group_name
  location            = var.location

  tags = local.common_tags
  lifecycle { ignore_changes = [tags] }
}
module "webapp" {
  source = "./modules/webapp"

  app_service_plan_name = "${local.prefix}-asp"
  webapp_name           = "${local.prefix}-webapp"

  resource_group_name = module.network.resource_group_name
  location            = var.location
  identity_id         = azurerm_user_assigned_identity.identity.id
  webapp_count        = var.webapp_count
  tags                = local.common_tags
}

resource "azurerm_key_vault" "main" {
  name                = replace("${local.prefix}kv", "-", "")
  location            = var.location
  resource_group_name = module.network.resource_group_name

  tenant_id = var.tenant_id
  sku_name  = "standard"

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  tags = local.common_tags
  lifecycle { ignore_changes = [tags] }
}
/*
resource "azurerm_key_vault_secret" "app_secret" {
  name         = "app-secret"
  value        = "HelloTerraform"
  key_vault_id = azurerm_key_vault.main.id
}
*/
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"

  principal_id = azurerm_user_assigned_identity.identity.principal_id
}
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.prefix}-law"
  location            = var.location
  resource_group_name = module.network.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = local.common_tags
  lifecycle { ignore_changes = [tags] }
}
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "${local.prefix}-storage-diag"
  target_resource_id         = "${module.storage.storage_account_id}/blobServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  metric {
    category = "Transaction"
  }
  metric {
    category = "Capacity"
    enabled  = false
  }
}
resource "azurerm_monitor_diagnostic_setting" "webapp" {
  name                       = "${local.prefix}-webapp-diag"
  target_resource_id         = module.webapp.webapp_id[0]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
