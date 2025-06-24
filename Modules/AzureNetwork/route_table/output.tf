## route table outputs
output "az_route_table_name" {
  description = "Route table name"
  value       = azurerm_route_table.az_route_table.name
}

output "az_route_table_id" {
  description = "Route table ID"
  value       = azurerm_route_table.az_route_table.id
}

## route table filter outputs
output "az_route_filter_id" {
  description = "Route table ID"
  value       = element(concat(azurerm_route_filter.az_route_filter.*.id, [""]), 0)
}

