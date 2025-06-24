module "key_vault_certificate" {
  source                     = "../modules/azurerm/KeyVault/key_vault_certificate"
  key_vault_certificate_name = var.key_vault_certificate_name
  key_vault_id               = module.keyvault.az_key_vault_id
  certificate_contents       = filebase64("certificate-to-import.pfx")
  certificate_password       = var.certificate_password
  tags                       = var.tags
  cert_policy_values         = var.cert_policy_values
}

