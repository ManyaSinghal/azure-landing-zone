terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~>3.0"
      configuration_aliases = [azurerm.platform, azurerm]
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
    subscription_id      = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"
    tenant_id            = "ec5684a4-78c4-485e-b260-85a99f06a0e9"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {}
  subscription_id = var.corp_subscription_id
}

# Provider configuration for corp landing zone subscription
provider "azurerm" {
  alias = "platform"
  features {}
  subscription_id = var.platform_subscription_id
}


# Azure AD provider
provider "azuread" {}