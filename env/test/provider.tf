terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
    backend "azurerm" {
      resource_group_name  = "rg_test_infra"
      storage_account_name = "prozynetfstateacc"
      container_name       = "tfstate"
      key                  = "test.terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}