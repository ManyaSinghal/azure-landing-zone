terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      configuration_aliases = [ azurerm.platform, azurerm ]
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
    key                  = "corp/terraform.tfstate"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id = var.corp_subscription_id
}

# Provider configuration for corp landing zone subscription
provider "azurerm" {
  alias = "platform"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id = var.platform_subscription_id
}


# Azure AD provider
provider "azuread" {}