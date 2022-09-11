module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.100.0.0/16"
  networks = [
    {
      name     = "aks_subnet"
      new_bits = 6
    },
  ]
}

resource "azurerm_virtual_network" "aks_virtual_network" {
  name                = "aks-${var.current_branch_name}-virtual-network"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  address_space       = [module.subnet_addrs.base_cidr_block]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-${var.current_branch_name}-subnet"
  resource_group_name = var.resource_group_name
  address_prefixes     = [module.subnet_addrs.networks[0].cidr_block]
  virtual_network_name = azurerm_virtual_network.aks_virtual_network.name
  # service_endpoints    = ["Microsoft.Sql"]
}