## key vault certificate outputs

output "az_key_vault_certificate_id" {
  description = "The Key Vault Certificate ID"
  value       = azurerm_key_vault_certificate.az_key_vault_certificate.id
}

output "az_key_vault_certificate_secret_id" {
  description = "The ID of the associated Key Vault Secret"
  value       = azurerm_key_vault_certificate.az_key_vault_certificate.secret_id
}

output "az_key_vault_certificate_version" {
  description = "The current version of the Key Vault Certificate"
  value       = azurerm_key_vault_certificate.az_key_vault_certificate.version
}
