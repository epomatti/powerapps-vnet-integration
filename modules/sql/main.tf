### SQL Server ###
data "azurerm_client_config" "current" {}

data "azuread_user" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_mssql_server" "default" {
  name                = "sqls-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  public_network_access_enabled = var.public_network_access_enabled

  # Administrator Login
  # administrator_login          = var.admin_login
  # administrator_login_password = var.admin_login_password

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = data.azuread_user.current.user_principal_name
    object_id                   = data.azurerm_client_config.current.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }

  # depends_on = [azurerm_role_assignment.key]
}

resource "azurerm_mssql_database" "default" {
  name                 = "sqldb-${var.workload}"
  server_id            = azurerm_mssql_server.default.id
  max_size_gb          = var.max_size_gb
  read_scale           = false
  sku_name             = var.sku
  zone_redundant       = false
  storage_account_type = "Local"
}

resource "azurerm_mssql_firewall_rule" "local" {
  count            = length(var.allowed_public_ips)
  name             = "FirewallRuleLocal_${count.index}"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = var.allowed_public_ips[count.index]
  end_ip_address   = var.allowed_public_ips[count.index]
}

# Allow Azure Services to connect.
resource "azurerm_mssql_firewall_rule" "allow_access_to_azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.default.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
