locals {
  name = "gateway"
}

resource "azurerm_public_ip" "default" {
  name                = "pip-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${local.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig001"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "default" {
  name                  = "vm-${local.name}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.gateway_size
  admin_username        = "azureuser"
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.default.id]
  secure_boot_enabled   = true

  os_disk {
    name                 = "osdisk-${local.name}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.gateway_publisher
    offer     = var.gateway_offer
    sku       = var.gateway_sku
    version   = var.gateway_version
  }
}
