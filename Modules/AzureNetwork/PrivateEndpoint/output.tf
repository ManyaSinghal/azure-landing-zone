## Private Endpoint outputs
output "az_private_endpoint_id" {
  value       = azurerm_private_endpoint.az_private_endpoint.id
  description = "Private Endpoint Id's"
}
output "az_private_dns_zone_group" {
  value       = azurerm_private_endpoint.az_private_endpoint.private_dns_zone_group
  description = "The ID of the Private DNS Zone Group"
}
output "az_private_enpoint_private_ip" {
  value       = azurerm_private_endpoint.az_private_endpoint.private_service_connection[0].private_ip_address
  description = "private endpoint assosiated private ip"
}
