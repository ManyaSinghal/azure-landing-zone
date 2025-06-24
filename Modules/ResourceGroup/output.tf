
# resource group outputs
output "az_resource_group_id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.az_resource_group.id
}

output "az_resource_group_name" {
  description = "The Azure resource group name "
  value       = azurerm_resource_group.az_resource_group.name
}

output "az_resource_group_location" {
  description = "A mapping of location assigned to the Resource Group"
  value       = azurerm_resource_group.az_resource_group.location
}

output "az_resource_group_tags" {
  description = "A mapping of tags assigned to the Resource Group"
  value       = azurerm_resource_group.az_resource_group.tags
}
