## Application Insights outputs

output "az_application_insights_id" {
  description = "The ID of the Application Insights component"
  value       = azurerm_application_insights.az_application_insights.id
}

output "az_application_insights_app_id" {
  description = "The App ID associated with this Application Insights component"
  value       = azurerm_application_insights.az_application_insights.app_id
}

output "az_application_insights_instrumentation_key" {
  description = "The Instrumentation Key for this Application Insights component"
  value       = azurerm_application_insights.az_application_insights.instrumentation_key
}

