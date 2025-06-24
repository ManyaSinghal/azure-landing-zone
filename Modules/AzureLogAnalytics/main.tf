# -
# - Azure log analystics workspace
# -
resource "azurerm_log_analytics_workspace" "az_log_analytics_workspace" {
  name                       = var.log_analytics_workspace
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.log_analytics_workspace_sku
  retention_in_days          = var.log_retention_in_days
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled
  tags                       = var.law_tags
}

# Link Automation Account to Log Analytics Workspace
resource "azurerm_log_analytics_linked_service" "automation_link" {
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.az_log_analytics_workspace.id
  read_access_id      = var.read_access_id
}