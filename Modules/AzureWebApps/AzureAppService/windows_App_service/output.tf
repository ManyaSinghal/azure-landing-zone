# App service outputs
output "az_app_service_id" {
  description = "Azure App service ID"
  value       = azurerm_windows_web_app.az_app_service.id
}

output "az_app_service_name" {
  value       = azurerm_windows_web_app.az_app_service.name
  description = "The name of the web app."
}

output "az_app_service_hostname" {
  value       = azurerm_windows_web_app.az_app_service.default_hostname
  description = "The default hostname of the web app."
}

# output "az_app_service_identity" {
#   value = {
#     principal_id = azurerm_windows_web_app.az_app_service.identity[0].principal_id
#     ids          = azurerm_windows_web_app.az_app_service.identity[0].identity_ids
#   }
#   description = "Managed service identity properties for the web app."
# }



output "az_app_service_outbound_ips" {
  value       = split(",", azurerm_windows_web_app.az_app_service.outbound_ip_addresses)
  description = "A list of outbound IP addresses for the web app."
}

output "az_app_service_possible_outbound_ips" {
  value       = split(",", azurerm_windows_web_app.az_app_service.possible_outbound_ip_addresses)
  description = "A list of possible outbound IP addresses for the web app. Superset of `outbound_ips`."
}
