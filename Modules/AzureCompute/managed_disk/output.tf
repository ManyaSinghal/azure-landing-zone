## managed_disk outputs

output "az_managed_disk_id" {
  description = "The ID of the Managed Disk"
  value       = azurerm_managed_disk.az_managed_disk.id
}