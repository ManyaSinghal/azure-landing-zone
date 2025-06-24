##  key vault secrets outputs
output "az_key_vault_secrets_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault_secret.az_key_vault_secrets.id
}

output "az_key_vault_secrets_value" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault_secret.az_key_vault_secrets.value
  sensitive   = true
}