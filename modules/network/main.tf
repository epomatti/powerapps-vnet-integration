resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_subnet" "powerapps" {
  name                 = "powerapps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.50.0/24"]

  private_link_service_network_policies_enabled = true

  delegation {
    name = "Microsoft.PowerPlatform/enterprisePolicies"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.PowerPlatform/enterprisePolicies"
    }
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2-${var.workload}"
  address_space       = ["10.99.0.0/16"]
  location            = var.pair_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "powerapps2" {
  name                 = "powerapps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.99.50.0/24"]

  private_link_service_network_policies_enabled = true

  delegation {
    name = "Microsoft.PowerPlatform/enterprisePolicies"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.PowerPlatform/enterprisePolicies"
    }
  }
}

# resource "azurerm_network_security_group" "default" {
#   name                = "nsg-${var.workload}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_network_security_rule" "allow_inbound_rdp" {
#   name                        = "AllowInboundRDP"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "3389"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.default.name
# }

# resource "azurerm_network_security_rule" "allow_outbound" {
#   name                        = "BastionOutbound"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.default.name
# }

# resource "azurerm_subnet_network_security_group_association" "default" {
#   subnet_id                 = azurerm_subnet.default.id
#   network_security_group_id = azurerm_network_security_group.default.id
# }
