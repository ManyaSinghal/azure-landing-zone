resource "azurerm_resource_group" "platform_management" {
  name     = var.platform_management_rg_name
  location = var.location
  tags = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_management.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days

  tags = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

resource "azurerm_automation_account" "automation" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_management.name
  sku_name            = "Basic"

  tags = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

# Link Automation Account to Log Analytics Workspace
resource "azurerm_log_analytics_linked_service" "automation_link" {
  resource_group_name = azurerm_resource_group.platform_management.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  read_access_id      = azurerm_automation_account.automation.id
}

# Enable Azure Sentinel (Microsoft Sentinel) if specified
# resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
#   count = var.sentinel_enabled ? 1 : 0

#   workspace_id = azurerm_log_analytics_workspace.log_analytics.id
# }