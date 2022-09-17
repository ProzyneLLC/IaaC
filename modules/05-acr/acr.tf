resource "azurerm_container_registry" "acr" {
  name                = "${var.current_branch_name}acrprozyne"
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  sku                 = var.acr_sku
}

data "azurerm_kubernetes_cluster" "aks-cluster" {
  name = "${var.current_branch_name}-aks"
  resource_group_name = var.resource_group_name
  
}

resource "azurerm_role_assignment" "aks-acr-role" {
  principal_id                     = data.azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}