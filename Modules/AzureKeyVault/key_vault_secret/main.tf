# -
# - Key vault secret
# -

resource "azurerm_key_vault_secret" "az_key_vault_secrets" {
  name            = var.key_secret_name
  value           = var.value
  key_vault_id    = var.key_vault_id
  content_type    = var.content_type
  not_before_date = var.not_before_date
  expiration_date = var.expiration_date
  tags            = var.key_secret_tags

  lifecycle {
    ignore_changes = [value]
  }
}

