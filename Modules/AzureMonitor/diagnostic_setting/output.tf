## monitor diagnostic settingoutputs

output "az_diagnostic_setting_id" {
  description = "The ID of the diagnostic_setting"
  value       = azurerm_monitor_diagnostic_setting.az_monitor_diagnostic_setting.*.id
}