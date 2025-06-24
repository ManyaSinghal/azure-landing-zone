data "azurerm_client_config" "current" {}

module "keyvault" {
  source               = "../modules/azurerm/KeyVault/key_vault"
  name                 = var.name
  location             = module.rg.az_resource_group_location
  resource_group_name  = module.rg.az_resource_group_name
  sku_name             = var.sku_name
  tenant_id            = data.azurerm_client_config.current.tenant_id
  key_vault_key_name   = var.key_vault_key_name
  key_type             = var.key_type
  key_size             = var.key_size
  tags                 = var.tags
  key_vault_key_tags   = var.key_vault_key_tags
  create_key_vault_key = var.create_key_vault_key
}

