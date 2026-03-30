
terraform {
  required_version = ">=0.14.11"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.46.0"
    }
  }
  backend "azurerm" {
    key = "demotestrg.tfstate"
  }
}
# Azure provider
provider "azurerm" {
  features {}
}
