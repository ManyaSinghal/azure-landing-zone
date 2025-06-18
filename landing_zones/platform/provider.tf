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
    key                  = "terraform.tfstate"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# Azure AD provider
provider "azuread" {
}