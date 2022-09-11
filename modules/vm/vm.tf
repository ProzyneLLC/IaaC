#Virtual Machine
resource "azurerm_virtual_machine" "hub-vm" {
  name                  = "hub-${var.current_branch_name}-vm"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.hub-nic.id]
  vm_size               = dsadsadsa

  storage_image_reference {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04-LTS"
  version   = "latest"
  }

  storage_os_disk {
  name              = "myosdisk1"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
  }

  os_profile {
  computer_name  = "hub-${var.current_branch_name}-vm"
  admin_username = sadasd
  admin_password = asdsadsa
  }

  os_profile_linux_config {
  disable_password_authentication = false
  }
}