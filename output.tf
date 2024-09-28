output "mssql_fully_qualified_domain_name" {
  value = module.mssql.server_fqdn
}

output "mssql_database_name" {
  value = module.mssql.database_name
}

output "powerapps_sqlservice_service_principal_display_name" {
  value = module.entra.powerapps_sqlservice_service_principal_display_name
}
