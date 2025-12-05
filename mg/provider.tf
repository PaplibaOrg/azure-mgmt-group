terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-state-eus-dev-001"
    storage_account_name = "sttfstateeusdev001"
    container_name       = "tfstate"
    key                  = "management-groups.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5"
    }
  }
}

provider "azurerm" {
  tenant_id = "99e184df-412c-45ed-b033-63f70449fe62"
  features {}
}



