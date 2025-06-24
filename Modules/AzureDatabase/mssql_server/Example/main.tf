
module "azure_mssql_server" {
  source                        = "../../../../modules/azurerm/AzureDatabase/mssql_server"
  msssql_server_name            = var.msssql_server_name
  location                      = module.rg.az_resource_group_location
  resource_group_name           = module.rg.az_resource_group_name
  administrator_login_name      = module.azure_mssql_server_userdetails.az_key_vault_secrets_id
  administrator_login_password  = module.azure_mssql_server_userdetails.az_key_vault_secrets_value
  mssql_server_version          = var.mssql_server_version
  identity_type                 = var.identity_type
  connection_policy             = var.connection_policy
  public_network_access_enabled = var.public_network_access_enabled
  mssql_server_tags             = var.mssql_server_tags

  # failover seconday 

  enable_failover_server            = var.enable_failover_server
  mssqlserver_secondary_server_name = "${var.msssql_server_name}-drseconday"
  failover_location                 = var.failover_location
  failover_resource_group_name      = module.rg.az_resource_group_name

  # failover group name
  failover_group_name             = "${var.msssql_server_name}-group"
  failover_database_list          = [module.azurerm_mssql_database.az_mssql_database_id]
  create_sql_virtual_network_rule = var.create_sql_virtual_network_rule
  virtual_network_rule_name       = "vnet_rule-${var.msssql_server_name}"
  allowed_subnet_names            = var.allowed_subnet_names
  firewall_rules                  = var.firewall_rules

  create_mssql_server_extended_auditing_policy = var.create_mssql_server_extended_auditing_policy
  storage_endpoint                             = module.storage_account.az_storage_account_primary_blob_endpoint
  storage_account_access_key                   = module.storage_account.az_storage_account_primary_access_key

  create_mssql_server_security_alert_policy    = var.create_mssql_server_security_alert_policy
  sc_policy_state                              = var.sc_policy_state
  create_mssql_server_vulnerability_assessment = var.create_mssql_server_vulnerability_assessment
  storage_container_path                       = "${module.storage_account.az_storage_account_primary_blob_endpoint}${module.storage_account.az_storage_account_name}/"

}



module "azure_mssql_server_userdetails" {
  source          = "../modules/azurerm/KeyVault/key_vault_secret"
  key_secret_name = "sqldemoadmin"
  value           = random_password.passwd.result
  key_vault_id    = data.azurerm_key_vault.key_vault.id
}


resource "random_password" "passwd" {
  length           = 24
  special          = true
  upper            = true
  override_special = "$#%"
}