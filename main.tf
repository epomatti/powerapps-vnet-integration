terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0.0"
    }
    power-platform = {
      source  = "microsoft/power-platform"
      version = ">= 3.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.0.0"
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

### Resource Groups ###
resource "azurerm_resource_group" "primary" {
  name     = "rg-${local.workload}-primary"
  location = var.primary_location
}

resource "azurerm_resource_group" "secondary" {
  name     = "rg-${local.workload}-secondary"
  location = var.secondary_location
}

### Networking ###
module "network_primary_site" {
  source              = "./modules/network"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  cidr_prefix         = var.primary_vnet_cidr_prefix
}

module "network_secondary_site" {
  source              = "./modules/network"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.secondary.name
  location            = azurerm_resource_group.secondary.location
  cidr_prefix         = var.secondary_vnet_cidr_prefix
}

### Database ###
module "mssql" {
  source              = "./modules/sql"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location

  allowed_public_ips            = var.allowed_public_ips
  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  public_network_access_enabled = var.mssql_public_network_access_enabled
  admin_login                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
  azuread_authentication_only   = var.mssql_azuread_authentication_only
}

### MSSQL Private Endpoints ###
module "entra" {
  source = "./modules/entra"
}

module "private_link_primary_site" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.primary.name
  location                    = azurerm_resource_group.primary.location
  vnet_id                     = module.network_primary_site.vnet_id
  private_endpoints_subnet_id = module.network_primary_site.private_endpoints_subnet_id
  sql_server_id               = module.mssql.server_id
}

module "private_link_secondary_site" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.secondary.name
  location                    = azurerm_resource_group.secondary.location
  vnet_id                     = module.network_secondary_site.vnet_id
  private_endpoints_subnet_id = module.network_secondary_site.private_endpoints_subnet_id
  sql_server_id               = module.mssql.server_id
}

module "enterprise_policy" {
  count                 = var.create_powerapps_enterprise_policy ? 1 : 0
  source                = "./modules/enterprise-policy"
  workload              = local.workload
  resource_group_id     = azurerm_resource_group.primary.id
  powerapps_location    = var.powerplatform_environment_location
  primary_vnet_id       = module.network_primary_site.vnet_id
  secondary_vnet_id     = module.network_secondary_site.vnet_id
  primary_subnet_name   = module.network_primary_site.powerapps_subnet_name
  secondary_subnet_name = module.network_secondary_site.powerapps_subnet_name
}

# module "nat" {
#   source              = "./modules/nat"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }

# module "monitor" {
#   source              = "./modules/monitor"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }








# module "gateway" {
#   count               = var.create_gateway ? 1 : 0
#   source              = "./modules/gateway"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
#   subnet_id           = module.network.gateway_subnet_id

#   gateway_size      = var.gateway_size
#   gateway_publisher = var.gateway_publisher
#   gateway_offer     = var.gateway_offer
#   gateway_sku       = var.gateway_sku
#   gateway_version   = var.gateway_version
# }
