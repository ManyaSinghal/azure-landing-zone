## key vault certificate issuer outputs
output "az_key_vault_certificate_issuer_id" {
  description = "The ID of the Key Vault Certificate Issuer"
  value       = azurerm_key_vault_certificate_issuer.az_key_vault_certificate_issuer.id
}