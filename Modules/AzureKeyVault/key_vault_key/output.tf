## key vault key outputs

output "az_key_vault_key_id" {
  description = "The Key Vault Key ID."
  value       = azurerm_key_vault_key.az_key_vault_key.id
}

output "az_key_vault_key_version" {
  description = "The current version of the Key Vault Key"
  value       = azurerm_key_vault_key.az_key_vault_key.version
}
