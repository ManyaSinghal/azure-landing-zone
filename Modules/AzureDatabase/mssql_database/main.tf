resource "azurerm_mssql_database" "this" {
  name           = var.db_name
  server_id      = var.server_id
  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant

  enclave_type                = var.enclave_type
  ledger_enabled              = var.ledger_enabled
  storage_account_type        = var.storage_account_type
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  min_capacity                = var.min_capacity

  tags = var.mssql_db_tags

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_days != null ? [1] : []
    content {
      retention_days = var.short_term_retention_days
    }
  }

  elastic_pool_id = var.elastic_pool_id

  dynamic "read_scale" {
    for_each = can(regex("^BC", var.sku_name)) ? [1] : []
    content {
      read_scale = var.read_scale
    }
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "this" {
  count                                   = var.enable_auditing ? 1 : 0
  database_id                             = azurerm_mssql_database.this.id
  storage_endpoint                        = var.audit_storage_endpoint
  storage_account_access_key              = var.audit_storage_key
  retention_in_days                       = var.audit_retention_days
  storage_account_access_key_is_secondary = false
  enabled                                 = var.enable_auditing
}
