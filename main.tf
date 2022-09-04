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
  # sp-clientId = var.sp-clientId
  # sp-clientSecret = var.sp-clientSecret
  # resource_location = var.resource_location
  # kubernetes_version = var.kubernetes_version
  # resource_group_name = var.resource_group_name
}