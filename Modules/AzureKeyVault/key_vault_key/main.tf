# -
# - Setup key_vault_key
# -

resource "azurerm_key_vault_key" "az_key_vault_key" {
  name            = var.key_vault_key_name
  key_vault_id    = var.key_vault_id
  key_type        = var.key_type
  key_size        = var.key_size
  curve           = var.key_type == "EC" ? var.curve : null
  key_opts        = var.key_opts
  not_before_date = var.not_before_date
  expiration_date = var.expiration_date
  tags            = var.key_vault_key_tags
}