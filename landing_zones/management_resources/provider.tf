terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }

  # Remote backend configuration for storing state in a different tenant
  backend "azurerm" {
    resource_group_name  = "rg-cc-storageaccount"
    storage_account_name = "sacmstfstate"
    container_name       = "terraform-state"
    key                  = "management/terraform.tfstate"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {}
}

# Azure AD provider
provider "azuread" {
}