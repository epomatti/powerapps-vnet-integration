resource "azurerm_nat_gateway" "default" {
  name                    = "nat-${var.workload}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  # zones                   = ["1"]
}
