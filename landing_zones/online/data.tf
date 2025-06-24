
data "azurerm_resource_group" "platform_connectivity" {
  name = var.platform_connectivity_rg_name
}

data "azurerm_resource_group" "platform_management" {
  name = var.platform_management_rg_name
}

data "azurerm_firewall" "platform_firewall" {
  name                = var.platform_azure_firewall_name
  resource_group_name = data.azurerm_resource_group.platform_connectivity.name
}

data "azurerm_log_analytics_workspace" "platform_law" {
  name                = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.platform_management.name
}

data "azurerm_virtual_network" "platform_vnet" {
  name                = var.platform_vnet_name
  resource_group_name = data.azurerm_resource_group.platform_connectivity.name
}