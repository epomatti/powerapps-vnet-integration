resource "azurerm_public_ip" "default" {
  name                = "pip-nat-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [var.zone]
}

resource "azurerm_nat_gateway" "default" {
  name                    = "nat-${var.workload}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [var.zone]
}

resource "azurerm_nat_gateway_public_ip_association" "gateway" {
  nat_gateway_id       = azurerm_nat_gateway.default.id
  public_ip_address_id = azurerm_public_ip.default.id
}

resource "azurerm_subnet_nat_gateway_association" "gateway" {
  subnet_id      = var.gateway_subnet_id
  nat_gateway_id = azurerm_nat_gateway.default.id
}
