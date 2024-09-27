output "server_fqdn" {
  value = azurerm_mssql_server.default.fully_qualified_domain_name
}
