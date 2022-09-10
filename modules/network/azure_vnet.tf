resource "azurerm_virtual_network" "Virtual_network" {
  name                = "${var.current_branch_name}-network"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}
