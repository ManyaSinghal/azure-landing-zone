## Azure log analystics workspace outputs

output "az_log_analytics_workspace_id" {
  description = "ID of log analytics workspace"
  value       = azurerm_log_analytics_workspace.az_log_analytics_workspace.id
}
