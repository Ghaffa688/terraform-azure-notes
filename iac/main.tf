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
