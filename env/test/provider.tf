terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
    backend "azurerm" {
      resource_group_name  = "prozyne-dev"
      storage_account_name = "devtfstateacc"
      container_name       = "devtfstate"
      key                  = "test.terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}