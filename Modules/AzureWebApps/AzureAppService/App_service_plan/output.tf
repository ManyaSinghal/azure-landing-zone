# - App service plan outputs
output "az_app_service_plan_id" {
  description = "Azure App service plan ID"
  value       = azurerm_app_service_plan.az_app_service_plan.id
}
