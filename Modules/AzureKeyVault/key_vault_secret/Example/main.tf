
module "keyvault" {
  source          = "../modules/azurerm/KeyVault/key_vault_secret"
  key_secret_name = var.key_secret_name
  value           = var.value
  key_vault_id    = module.keyvault.az_key_vault_id
  content_type    = var.content_type
  key_secret_tags = var.tags
}

