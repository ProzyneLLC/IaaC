module "network" {
  source = "../../modules/network"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location = var.resource_location
}

module "aks" {
  source = "../../modules/aks/"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location = var.resource_location

  # sp_client_id = var.sp_client_id
  # sp_client_secret = var.sp_client_secret
  kubernetes_version = "1.23.8"
  aks_vnet_subnet_id = module.network.aks_vnet_subnet_id
  aks_node_size = "Standard_B2s"
  aks_node_type = "VirtualMachineScaleSets"
  aks_node_count = 1
  aks_node_disk_size = 50
}

module "nignx_ingress_controller" {
  source = "../../modules/nginx_ingress_controller"

  current_branch_name = var.current_branch_name
  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location = var.resource_location

  #Public IP var
  cluster_name = module.aks.cluster_name
  public_ip_allocation_method = "Static"
  public_ip_sku = "Basic"

  #Helm var
  nginx_helm_name = "ingress-nginx"
  nginx_helm_repository = "https://kubernetes.github.io/ingress-nginx"
  nginx_helm_chart = "ingress-nginx"
  # nginx_helm_version = "4.2.5"
  nginx_helm_namespace = "ingress-nginx"
  nginx_helm_create_namespace = "true"
  nginx_ingress_controller_replica_count = "1"
  nginx_ingress_controller_node_selector = "linux"
  nginx_ingress_defaultBackend_node_selector = "linux"
  nginx_ingress_service_type = "LoadBalancer"
  nginx_ingress_service_external_traffic_policy = "Local"
  nginx_ingress_controller_service_annotations = "rg_${var.current_branch_name}_infra"
}

module "k8s" {
  source = "../../modules/k8s/"
}