
module "key_vault_certificate_issuer" {
  source       = "../modules/azurerm/KeyVault/key_vault_certificate_issuer"
  key_vault_id = module.keyvault.az_key_vault_id
  name         = var.name
  password     = var.password
  admin_values = var.admin_values
}

