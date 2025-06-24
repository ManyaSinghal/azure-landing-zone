module "azure_mssql_database" {
  source              = "../modules/azurerm/AzureDatabase/mssql_database"
  mssql_database_name = var.mssql_database_name
  mssql_server_id     = module.azure_mssql_server.az_mssql_server_id
  collation           = var.collation
  license_type        = var.license_type
  max_size_gb         = var.max_size_gb
  sku_name            = var.sku_name
  create_mode         = var.create_mode
  mssql_db_tags       = var.mssql_db_tags
}

