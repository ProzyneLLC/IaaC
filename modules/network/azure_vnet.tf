resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = 
  resource_group_name = 
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}
