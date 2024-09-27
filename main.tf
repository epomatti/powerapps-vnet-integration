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
}

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
}
