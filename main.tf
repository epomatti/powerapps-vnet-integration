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
  affix        = random_integer.affix.result
  workload     = "${var.project}${local.affix}"
  gateway_zone = "1"
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
  source                     = "./modules/network"
  workload                   = local.workload
  resource_group_name        = azurerm_resource_group.primary.name
  location                   = azurerm_resource_group.primary.location
  cidr_prefix                = var.primary_vnet_cidr_prefix
  gateway_allowed_public_ips = var.allowed_public_ips
}

module "network_secondary_site" {
  source                     = "./modules/network"
  workload                   = local.workload
  resource_group_name        = azurerm_resource_group.secondary.name
  location                   = azurerm_resource_group.secondary.location
  cidr_prefix                = var.secondary_vnet_cidr_prefix
  gateway_allowed_public_ips = var.allowed_public_ips
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

### Private Endpoints ###
module "entra" {
  source = "./modules/entra"
}

module "private_link_primary_site" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.primary.name
  location                    = azurerm_resource_group.primary.location
  site_affix                  = "primary"
  vnet_id                     = module.network_primary_site.vnet_id
  private_endpoints_subnet_id = module.network_primary_site.private_endpoints_subnet_id
  sql_server_id               = module.mssql.server_id
}

module "private_link_secondary_site" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.secondary.name
  location                    = azurerm_resource_group.secondary.location
  site_affix                  = "secondary"
  vnet_id                     = module.network_secondary_site.vnet_id
  private_endpoints_subnet_id = module.network_secondary_site.private_endpoints_subnet_id
  sql_server_id               = module.mssql.server_id
}

### Power Apps ###
module "enterprise_policy" {
  count                 = var.create_powerapps_enterprise_policy ? 1 : 0
  source                = "./modules/powerapps/enterprise-policy"
  workload              = local.workload
  resource_group_id     = azurerm_resource_group.primary.id
  powerapps_location    = var.powerplatform_environment_location
  primary_vnet_id       = module.network_primary_site.vnet_id
  secondary_vnet_id     = module.network_secondary_site.vnet_id
  primary_subnet_name   = module.network_primary_site.powerapps_subnet_name
  secondary_subnet_name = module.network_secondary_site.powerapps_subnet_name
}

module "gateway" {
  count                  = var.create_onprem_data_gateway ? 1 : 0
  source                 = "./modules/gateway"
  workload               = local.workload
  resource_group_name    = azurerm_resource_group.primary.name
  location               = azurerm_resource_group.primary.location
  subnet_id              = module.network_primary_site.gateway_subnet_id
  zone                   = local.gateway_zone
  gateway_admin_username = var.gateway_admin_username
  gateway_admin_password = var.gateway_admin_password

  gateway_size      = var.gateway_size
  gateway_publisher = var.gateway_publisher
  gateway_offer     = var.gateway_offer
  gateway_sku       = var.gateway_sku
  gateway_version   = var.gateway_version
}



module "nat" {
  count               = var.create_nat_gateway ? 1 : 0
  source              = "./modules/nat"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  zone                = local.gateway_zone
  gateway_subnet_id   = module.network_primary_site.gateway_subnet_id
}


# module "powerapps_managed_environment" {
#   count                       = var.create_powerapps_environment ? 1 : 0
#   source                      = "./modules/powerapps/managed-environment"
#   primary_resource_group_name = azurerm_resource_group.primary.name
#   powerapps_location          = var.powerplatform_environment_location
# }



# module "monitor" {
#   source              = "./modules/monitor"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }








