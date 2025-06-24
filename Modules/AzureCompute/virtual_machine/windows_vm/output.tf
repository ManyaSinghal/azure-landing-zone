## virtual machine linux output

output "az_virtual_machine_windows_id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_virtual_machine.az_virtual_machine_windows.id
}
