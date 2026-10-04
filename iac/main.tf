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

  resource_group_name          = "${local.prefix}-rg"
  location                     = var.location
  vnet_name                    = "${local.prefix}-vnet"
  app_subnet_name              = "${local.prefix}-app-subnet"
  private_endpoint_subnet_name = "${local.prefix}-pe-subnet"

  tags = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  storage_account_name = replace("${local.prefix}storage", "-", "")
  resource_group_name  = module.network.resource_group_name
  location             = var.location

  subnet_id = module.network.private_endpoint_subnet_id

  tags = local.common_tags
}
module "identity" {
  source = "./modules/identity"

  identity_name = "${local.prefix}-identity"

  resource_group_name = module.network.resource_group_name
  location            = var.location

  tags = local.common_tags
}
module "webapp" {
  source = "./modules/webapp"

  app_service_plan_name = "${local.prefix}-asp"
  webapp_name           = "${local.prefix}-webapp"

  resource_group_name = module.network.resource_group_name
  location            = var.location
  identity_id         = module.identity.identity_id
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
}
resource "azurerm_key_vault_secret" "app_secret" {
  name         = "app-secret"
  value        = "HelloTerraform"
  key_vault_id = azurerm_key_vault.main.id
}
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"

  principal_id = module.identity.principal_id
}