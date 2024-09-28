terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.1"
    }
    power-platform = {
      source  = "microsoft/power-platform"
      version = "3.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
  }
}

resource "random_integer" "affix" {
  min = 100
  max = 999
}

locals {
  affix    = random_integer.affix.result
  workload = "${var.project}${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  pair_location       = var.pair_location
}

# module "nat" {
#   source              = "./modules/nat"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }

module "monitor" {
  source              = "./modules/monitor"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "mssql" {
  source              = "./modules/sql"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  allowed_public_ips            = var.allowed_public_ips
  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  public_network_access_enabled = var.mssql_public_network_access_enabled
  admin_login                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
  azuread_authentication_only   = var.mssql_azuread_authentication_only
}

module "private_link" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.default.name
  location                    = azurerm_resource_group.default.location
  vnet_id                     = module.network.vnet_id
  private_endpoints_subnet_id = module.network.private_endpoints_subnet_id
  sql_server_id               = module.mssql.server_id
}

module "enterprise_policy" {
  source                 = "./modules/policy"
  workload               = local.workload
  resource_group_id      = azurerm_resource_group.default.id
  powerapps_location     = var.powerplatform_environment_location
  vnet_id                = module.network.vnet_id
  powerapps_subnet_name  = module.network.powerapps_subnet_name
  vnet2_id               = module.network.vnet2_id
  powerapps_subnet2_name = module.network.powerapps_subnet2_name
}

module "entra" {
  source = "./modules/entra"
}
