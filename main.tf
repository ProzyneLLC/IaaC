terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aks" {
  source = "./modules/aks/"
}

module "k8s" {
  source = "./modules/k8s/"
  host                  = "${module.aks.host}"
  client_certificate    = "${base64decode(module.aks.client_certificate)}"
  client_key            = "${base64decode(module.aks.client_key)}"
  cluster_ca_certificate= "${base64decode(module.aks.cluster_ca_certificate)}"
}