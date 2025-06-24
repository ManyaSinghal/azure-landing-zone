## loganalytics for all subscrions

module "platform_log_analytics" {
  source                      = "../../Modules/AzureLogAnalytics"
  log_analytics_workspace     = var.log_analytics_workspace
  location                    = module.platform_rgs["rg1"].az_resource_group_location
  resource_group_name         = module.platform_rgs["rg1"].az_resource_group_name
  log_analytics_workspace_sku = "PerGB2018"
  law_tags                    = module.platform_rgs["rg1"].az_resource_group_tags
  log_retention_in_days       = 30
  read_access_id              = azurerm_automation_account.automation.id
}
# Link Automation Account to Log Analytics Workspace
resource "azurerm_automation_account" "automation" {
  name                = var.automation_account_name
  location            = module.platform_rgs["rg1"].az_resource_group_location
  resource_group_name = module.platform_rgs["rg1"].az_resource_group_name
  sku_name            = "Basic"
  tags                = module.platform_rgs["rg1"].az_resource_group_tags
}

# Enable Azure Sentinel (Microsoft Sentinel) if specified
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = module.platform_log_analytics.az_log_analytics_workspace_id
}