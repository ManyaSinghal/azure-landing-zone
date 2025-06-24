
output "az_appgw_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.az_application_gateway.id
}

output "az_appgw_name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.az_application_gateway.name
}


output "az_appgw_backend_address_pool_ids" {
  description = "List of backend address pool Ids."
  value       = azurerm_application_gateway.az_application_gateway.backend_address_pool.*.id
}

output "az_appgw_backend_http_settings_ids" {
  description = "List of backend HTTP settings Ids."
  value       = azurerm_application_gateway.az_application_gateway.backend_http_settings.*.id
}

output "az_appgw_backend_http_settings_probe_ids" {
  description = "List of probe Ids from backend HTTP settings."
  value       = azurerm_application_gateway.az_application_gateway.backend_http_settings.*.probe_id
}

output "az_appgw_frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration Ids."
  value       = azurerm_application_gateway.az_application_gateway.frontend_ip_configuration.*.id
}

output "az_appgw_frontend_port_ids" {
  description = "List of frontend port Ids."
  value       = azurerm_application_gateway.az_application_gateway.frontend_port.*.id
}

output "az_appgw_gateway_ip_configuration_ids" {
  description = "List of IP configuration Ids."
  value       = azurerm_application_gateway.az_application_gateway.gateway_ip_configuration.*.id
}

output "az_appgw_http_listener_ids" {
  description = "List of HTTP listener Ids."
  value       = azurerm_application_gateway.az_application_gateway.http_listener.*.id
}

output "az_appgw_http_listener_frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration Ids from HTTP listeners."
  value       = azurerm_application_gateway.az_application_gateway.http_listener.*.frontend_ip_configuration_id
}

output "az_appgw_http_listener_frontend_port_ids" {
  description = "List of frontend port Ids from HTTP listeners."
  value       = azurerm_application_gateway.az_application_gateway.http_listener.*.frontend_port_id
}

output "az_appgw_request_routing_rule_ids" {
  description = "List of request routing rules Ids."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.id
}

output "az_appgw_request_routing_rule_http_listener_ids" {
  description = "List of HTTP listener Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.http_listener_id
}

output "az_appgw_request_routing_rule_backend_address_pool_ids" {
  description = "List of backend address pool Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.backend_address_pool_id
}

output "az_appgw_request_routing_rule_backend_http_settings_ids" {
  description = "List of HTTP settings Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.backend_http_settings_id
}

output "az_appgw_request_routing_rule_redirect_configuration_ids" {
  description = "List of redirect configuration Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.redirect_configuration_id
}

output "az_appgw_request_routing_rule_rewrite_rule_set_ids" {
  description = "List of rewrite rule set Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.rewrite_rule_set_id
}

output "az_appgw_request_routing_rule_url_path_map_ids" {
  description = "List of URL path map Ids attached to request routing rules."
  value       = azurerm_application_gateway.az_application_gateway.request_routing_rule.*.url_path_map_id
}

output "az_appgw_ssl_certificate_ids" {
  description = "List of SSL certificate Ids."
  value       = azurerm_application_gateway.az_application_gateway.ssl_certificate.*.id
}

output "az_appgw_url_path_map_ids" {
  description = "List of URL path map Ids."
  value       = azurerm_application_gateway.az_application_gateway.url_path_map.*.id
}

output "az_appgw_url_path_map_default_backend_address_pool_ids" {
  description = "List of default backend address pool Ids attached to URL path maps."
  value       = azurerm_application_gateway.az_application_gateway.url_path_map.*.default_backend_address_pool_id
}

# output "appgw_url_path_map_default_backend_http_settings_ids" {
#   description = "List of default backend HTTP settings Ids attached to URL path maps."
#   value       = azurerm_application_gateway.az_application_gateway.url_path_map.*.default_backend_http_settings_id
# }

# output "appgw_url_path_map_default_redirect_configuration_ids" {
#   description = "List of default redirect configuration Ids attached to URL path maps."
#   value       = azurerm_application_gateway.az_application_gateway.url_path_map.*.default_redirect_configuration_id
# }

# output "appgw_custom_error_configuration_ids" {
#   description = "List of custom error configuration Ids."
#   value       = azurerm_application_gateway.az_application_gateway.custom_error_configuration.*.id
# }

# output "appgw_redirect_configuration_ids" {
#   description = "List of redirect configuration Ids."
#   value       = azurerm_application_gateway.az_application_gateway.redirect_configuration.*.id
# }