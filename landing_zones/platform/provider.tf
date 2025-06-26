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
    key                  = "platform/terraform.tfstate"
    # Use a service principal to access the storage account in a different tenant
    # This requires creating a service principal with appropriate permissions
    # These values should be passed via environment variables or CLI parameters
    subscription_id = var.platform_subscription_id
    tenant_id       = "ec5684a4-78c4-485e-b260-85a99f06a0e9"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  # Use a service principal to access the storage account in a different tenant
  # This requires creating a service principal with appropriate permissions
  # These values should be passed via environment variables or CLI parameters
  tenant_id       = "ec5684a4-78c4-485e-b260-85a99f06a0e9"
  subscription_id = var.platform_subscription_id
}

# Azure AD provider
provider "azuread" {
}