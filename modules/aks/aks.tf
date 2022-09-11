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
  # private_dns_zone_id = "System"
  # private_cluster_enabled = true
  # private_cluster_public_fqdn_enabled = true
  azure_policy_enabled = false
  # http_application_routing_enabled = false
  oidc_issuer_enabled = false
  open_service_mesh_enabled = false
  role_based_access_control_enabled = true
  run_command_enabled = true
  
  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_size
    type       = var.aks_node_type
    os_disk_size_gb = var.aks_node_disk_size
    vnet_subnet_id = var.aks_vnet_subnet_id
  }

  service_principal  {
    client_id = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = data.azurerm_ssh_public_key.ssh_key.public_key
    }
  }

  network_profile {
    network_plugin = "azure"###########################################maybe vnet not setup correctly, check kubnet###############################################################
    load_balancer_sku = "basic"
  }

}

