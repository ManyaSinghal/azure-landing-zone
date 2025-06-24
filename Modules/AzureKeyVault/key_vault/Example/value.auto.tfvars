name                 = "test-kv-demo"
sku_name             = "Standard"
create_key_vault_key = false
key_vault_key_name   = "test-kv-key"

key_vault_key_tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}