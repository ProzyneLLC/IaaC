terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
    backend "azurerm" {
      resource_group_name  = "rg_${var.current_branch_name}_infra"
      storage_account_name = "prozynetfstateacc"
      container_name       = "tfstate"
      key                  = "${var.current_branch_name}.terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}