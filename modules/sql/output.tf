output "server_fqdn" {
  value = azurerm_mssql_server.default.fully_qualified_domain_name
}

output "server_id" {
  value = azurerm_mssql_server.default.id
}

output "database_name" {
  value = azurerm_mssql_database.default.name
}
