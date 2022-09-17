data "azurerm_ssh_public_key" "ssh_key" {
  name                = "${var.current_branch_name}_aks_ssh_key"
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                  = "${var.current_branch_name}-aks"
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.current_branch_name}-aks"
  kubernetes_version    =  var.kubernetes_version
  azure_policy_enabled = false
  oidc_issuer_enabled = false
  
  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_size
    type       = var.aks_node_type
    os_disk_size_gb = var.aks_node_disk_size
  }

  linux_profile {
    admin_username = "${var.current_branch_name}_azureuser"
    ssh_key {
      key_data = data.azurerm_ssh_public_key.ssh_key.public_key
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = var.aks_network_plugin
    load_balancer_sku = var.aks_load_balancer_sku
  }

}