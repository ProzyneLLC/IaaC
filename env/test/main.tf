module "netowork" {
  source = "../../modules/network"

  resource_group_name = "rg_${var.current_branch_name}_infra"
  resource_location = var.resource_location
}

# module "aks" {
#   source = "./modules/aks/"
# }

# module "k8s" {
#   source = "./modules/k8s/"
#   host                  = "${module.aks.host}"
#   client_certificate    = "${base64decode(module.aks.client_certificate)}"
#   client_key            = "${base64decode(module.aks.client_key)}"
#   cluster_ca_certificate= "${base64decode(module.aks.cluster_ca_certificate)}"
# }