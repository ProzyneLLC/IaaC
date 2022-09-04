data "azurerm_ssh_public_key" "prozyne-dev-key" {
  name                = "dev-key"
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "prozyne-aks-dev" {
  name                  = "prozyne-aks-dev"
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "prozyne-aks-dev"
  kubernetes_version    =  var.kubernetes_version
  private_dns_zone_id = "System"
  private_cluster_enabled = false
  private_cluster_public_fqdn_enabled = true
  azure_policy_enabled = false
  http_application_routing_enabled = false
  oidc_issuer_enabled = false
  open_service_mesh_enabled = false
  role_based_access_control_enabled = true
  run_command_enabled = true
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    type       = "VirtualMachineScaleSets"
    os_disk_size_gb = 50
  }

  service_principal  {
    client_id = var.sp-clientId
    client_secret = var.sp-clientSecret
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = data.azurerm_ssh_public_key.prozyne-dev-key.public_key
    }
  }

  network_profile {
      network_plugin = "kubenet"
  }

}