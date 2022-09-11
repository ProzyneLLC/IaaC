resource "azurerm_public_ip" "cluster-pub-ip" {
  name                = "${var.current_branch_name}-${var.cluster_name}-pub-ip"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}