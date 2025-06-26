
data "azurerm_resource_group" "platform_connectivity" {
  provider = azurerm.platform
  name     = var.platform_connectivity_rg_name
}

data "azurerm_resource_group" "platform_management" {
  provider = azurerm.platform
  name     = var.platform_management_rg_name
}

data "azurerm_resource_group" "platform_identity" {
  provider = azurerm.platform
  name     = var.platform_identity_rg_name
}

data "azurerm_key_vault" "platform_kv" {
  provider            = azurerm.platform
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.platform_identity.name
}

data "azurerm_firewall" "platform_firewall" {
  provider            = azurerm.platform
  name                = var.platform_azure_firewall_name
  resource_group_name = data.azurerm_resource_group.platform_connectivity.name
}

data "azurerm_log_analytics_workspace" "platform_law" {
  provider            = azurerm.platform
  name                = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.platform_management.name
}

data "azurerm_virtual_network" "platform_vnet" {
  provider            = azurerm.platform
  name                = var.platform_vnet_name
  resource_group_name = data.azurerm_resource_group.platform_connectivity.name
}