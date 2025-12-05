terraform {
  backend "azurerm" {
    # Backend configuration is passed via -backend-config flags from pipeline
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



