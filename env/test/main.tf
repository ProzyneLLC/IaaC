# module "network" {
#   source = "../../modules/01-network"

#   current_branch_name = var.current_branch_name
#   resource_group_name = "rg-${var.current_branch_name}-infrastructure"
#   resource_location = var.resource_location
# }

module "aks" {
  source = "../../modules/02-aks/"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location   = var.resource_location

  #AKS configuration
  kubernetes_version = "1.23.8"
  azure_policy_enabled = false
  oidc_issuer_enabled = false
  
  #Default node pool
  aks_d_node_name = "default"
  aks_d_node_size      = "Standard_B2s"
  aks_d_node_type      = "VirtualMachineScaleSets"
  aks_d_node_count     = 1
  aks_d_node_disk_size = 50

  #User node pool
  aks_u_node_name = "user"
  aks_u_node_size = "Standard_B2s"
  aks_u_node_count = 1
  aks_u_node_disk_size = 50

  #AKS network profile
  aks_network_plugin = "kubenet"
  aks_load_balancer_sku = "standard"
}

module "acr" {
  depends_on = [module.aks]
  source = "../../modules/05-acr/"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location   = var.resource_location

  #ACR config
  acr_sku = "Basic"
}

module "helm_nignx_ingress_controller" {
  depends_on = [module.aks]
  source     = "../../modules/03-nginx-ingress/"

  #Helm var
  nginx_helm_name       = "ingress-nginx"
  nginx_helm_repository = "https://kubernetes.github.io/ingress-nginx"
  nginx_helm_chart      = "ingress-nginx"
  # nginx_helm_version = "4.2.5"
  nginx_helm_namespace                          = "ingress-nginx"
  nginx_helm_create_namespace                   = "true"
  
  #Set var
  nginx_ingress_controller_replica_count        = "1"
  nginx_ingress_controller_node_selector        = "linux"
  nginx_ingress_defaultBackend_node_selector    = "linux"
  nginx_ingress_service_type                    = "LoadBalancer"
  nginx_ingress_service_external_traffic_policy = "Local"
}

module "helm_cert_manager" {
  depends_on = [module.helm_nignx_ingress_controller, module.aks]
  source     = "../../modules/04-cert-manager/"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location   = var.resource_location

  #Helm var
  cert_manager_helm_name       = "cert-manager"
  cert_manager_helm_repository = "https://charts.jetstack.io"
  cert_manager_helm_chart      = "cert-manager"
  # cert_manager_helm_version = "v1.7.1"
  cert_manager_helm_namespace        = "cert-manager"
  cert_manager_helm_create_namespace = "true"

  #Set var
  cert_manager_install_CRD           = "true"
  cert_manager_replica_count         = "1"
  cert_manager_node_selector         = "linux"

  #ClusterIssuer var
  letsencrypt_email                = "pierreridderstap@gmail.com"
  letsencrypt_cloudflare_api_token = var.letsencrypt_cloudflare_api_token
}

# module "mysqldb" {
#   depends_on = [module.helm_cert_manager]
#   source = "../../modules/06-mysqldb/"

#   current_branch_name = var.current_branch_name
#   resource_group_name = "rg_${var.current_branch_name}_infra"
#   resource_location   = var.resource_location

#   #MySQL config
#   mysql_backup_retention_days = 7
#   mysql_sku = "B_Standard_B1s"
# }

module "demo_app" {
  depends_on = [module.aks, module.acr, module.helm_nignx_ingress_controller]
  source     = "../../modules/demo-web-app-pod/"
}