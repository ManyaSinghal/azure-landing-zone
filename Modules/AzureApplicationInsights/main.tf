# -
# - Application Insights
# -
resource "azurerm_application_insights" "az_application_insights" {
  name                                  = var.application_insights_name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  application_type                      = var.application_type
  retention_in_days                     = var.retention_in_days
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  tags                                  = var.application_insights_tags
  workspace_id                          = var.workspace_id
}
