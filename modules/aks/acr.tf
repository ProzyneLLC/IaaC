data "azuread_service_principal" "akssp"{
    display_name = "SP-tf-pipeline"
}

data "azurerm_kubernetes_cluster" "aks" {
  name                  = "${var.current_branch_name}-aks"
  resource_group_name = var.resource_group_name

depends_on = [ azurerm_kubernetes_cluster.aks] 
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.current_branch_name}ContainerRegistry1Prozyne"
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = data.azuread_service_principal.akssp.object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}