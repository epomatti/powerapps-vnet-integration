resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# resource "azurerm_application_insights" "default" {
#   name                = "appi-${var.workload}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   workspace_id        = azurerm_log_analytics_workspace.default.id
#   application_type    = "web"
# }
