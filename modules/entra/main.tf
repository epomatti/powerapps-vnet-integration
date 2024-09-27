data "azuread_client_config" "current" {}

resource "azuread_application" "powerapps" {
  display_name = "powerapps-sqlservice"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "powerapps" {
  client_id = azuread_application.powerapps.client_id
  owners    = [data.azuread_client_config.current.object_id]
}
