output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "powerapps_subnet_id" {
  value = azurerm_subnet.powerapps.id
}

output "powerapps_subnet_name" {
  value = azurerm_subnet.powerapps.name
}
