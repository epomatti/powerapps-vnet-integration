resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["${var.cidr_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.cidr_prefix}.10.0/24"]
}

resource "azurerm_subnet" "powerapps" {
  name                                          = "powerapps"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.default.name
  address_prefixes                              = ["${var.cidr_prefix}.20.0/24"]
  private_link_service_network_policies_enabled = true

  delegation {
    name = "Microsoft.PowerPlatform/enterprisePolicies"
    service_delegation {
      name = "Microsoft.PowerPlatform/enterprisePolicies"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "gateway" {
  name                 = "data-gateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.cidr_prefix}.30.0/24"]
}

### On-Premises Data Gateway ###
resource "azurerm_network_security_group" "gateway" {
  name                = "nsg-${var.workload}-onprem-data-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_gateway_inbound_rdp" {
  name                        = "AllowInboundRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = var.gateway_allowed_public_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.gateway.name
}

resource "azurerm_subnet_network_security_group_association" "gateway_allow_inbound_rdp" {
  subnet_id                 = azurerm_subnet.gateway.id
  network_security_group_id = azurerm_network_security_group.gateway.id
}
