# -
# - Setup key vault 
# -
resource "azurerm_key_vault" "az_key_vault" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku_name                        = var.sku_name
  tenant_id                       = var.tenant_id
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days

  # network_acls config block
  dynamic "network_acls" {
    for_each = var.network_acls
    content {
      bypass                     = lookup(network_acls.value, "bypass", null)
      default_action             = lookup(network_acls.value, "default_action", null)
      ip_rules                   = lookup(network_acls.value, "ip_rules", null)
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", null)
    }
  }

  # contact config block
  dynamic "contact" {
    for_each = lookup(var.contact, "contact", {})
    content {
      email = lookup(contact.value, "email", null)
      name  = lookup(name.value, "name", null)
      phone = lookup(phone.value, "phone", null)
    }
  }

  tags = var.key_vault_tags
}


# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy" {
  for_each                = var.policies
  key_vault_id            = azurerm_key_vault.az_key_vault.id
  tenant_id               = lookup(each.value, "tenant_id")
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, "secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
  storage_permissions     = lookup(each.value, "storage_permissions")
}