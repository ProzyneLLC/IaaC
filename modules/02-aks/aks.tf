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
  azure_policy_enabled = var.azure_policy_enabled
  oidc_issuer_enabled = var.oidc_issuer_enabled
  
  default_node_pool {
    name       = var.aks_d_node_name
    node_count = var.aks_d_node_count
    vm_size    = var.aks_d_node_size
    type       = var.aks_d_node_type
    os_disk_size_gb = var.aks_d_node_disk_size
    node_labels = {
      nodeLabel = "system"
    }
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

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = var.aks_u_node_name
  vm_size               = var.aks_u_node_size
  node_count            = var.aks_u_node_count
  os_disk_size_gb = var.aks_u_node_disk_size
  node_labels = {
    nodeLabel = "user"
  }
}