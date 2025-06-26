
data "azurerm_resource_group" "platform_connectivity" {
  name = var.platform_connectivity_rg_name
}

data "azurerm_resource_group" "platform_management" {
  name = var.platform_management_rg_name
}

data "azurerm_resource_group" "platform_identity" {
  name = var.platform_identity_rg_name
}

data "azurerm_key_vault" "platform_kv" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.platform_identity.name
}

data "azurerm_log_analytics_workspace" "platform_law" {
  name                = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.platform_management.name
}

data "azurerm_virtual_network" "platform_vnet" {
  name                = var.platform_vnet_name
  resource_group_name = data.azurerm_resource_group.platform_connectivity.name
}