# -
# # - Setup key vault certificate_issuer
# -

resource "azurerm_key_vault_certificate_issuer" "az_key_vault_certificate_issuer" {
  name          = var.name
  key_vault_id  = var.key_vault_id
  provider_name = var.provider_name
  org_id        = var.org_id
  account_id    = var.account_id
  password      = var.password

  dynamic "admin" {
    for_each = try(var.settings.admin_settings, {})
    content {
      email_address = admin.value.email_address
      first_name    = admin.value.first_name
      last_name     = admin.value.last_name
      phone         = admin.value.phone_number
    }

  }
}