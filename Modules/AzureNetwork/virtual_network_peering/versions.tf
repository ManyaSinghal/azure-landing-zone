## terraform and providers version
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~>3.0"
      configuration_aliases = [azurerm, azurerm.dest]
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "dest"
  features {}
}


