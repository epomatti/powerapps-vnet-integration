data "azuread_client_config" "current" {}

locals {
  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_application" "powerapps" {
  display_name = "PowerAppsUser"
  owners       = local.owners
}

resource "azuread_service_principal" "powerapps" {
  client_id = azuread_application.powerapps.client_id
  owners    = local.owners
}
