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
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatesatestpresan"
    container_name       = "terraform-state"
    key                  = "management/terraform.tfstate"
  }
}

# Provider configuration for platform subscription
provider "azurerm" {
  features {}
  subscription_id = var.online_subscription_id
}

# Azure AD provider
provider "azuread" {
}

# Provider configuration for corp landing zone subscription
provider "azurerm" {
  alias = "platform"
  features {}
  subscription_id = var.platform_subscription_id
}