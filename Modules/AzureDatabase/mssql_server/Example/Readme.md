# Create mssql server in Azure
This Module allows you to create and manage one or multiple mssql server in Microsoft Azure.

## Features
This module will:

- Create one or muliple mssql server in Microsoft Azure.

## Usage
```hcl
module "azure_mssql_server" {
  source                        = "../../../../modules/azurerm/Azureserver/mssql_server"
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
  failover_group_name                               = "${var.msssql_server_name}-group"
  failover_server_list                            = [module.azurerm_mssql_server.az_mssql_server_id]
  create_sql_virtual_network_rule = var.create_sql_virtual_network_rule
  virtual_network_rule_name       = "vnet_rule-${var.msssql_server_name}"
  allowed_subnet_names            = var.allowed_subnet_names
  firewall_rules = var.firewall_rules

  create_mssql_server_extended_auditing_policy = var.create_mssql_server_extended_auditing_policy
  storage_endpoint                             = module.storage_account.az_storage_account_primary_blob_endpoint
  storage_account_access_key                   = module.storage_account.az_storage_account_primary_access_key

  create_mssql_server_security_alert_policy = var.create_mssql_server_security_alert_policy
  sc_policy_state                           = var.sc_policy_state
  create_mssql_server_vulnerability_assessment = var.create_mssql_server_vulnerability_assessment
  storage_container_path                       = "${module.storage_account.az_storage_account_primary_blob_endpoint}${module.storage_account.az_storage_account_name}/"

}
```

## Example 
Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the resource group module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the resource group module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the resource group module.

## Best practices for variable declaration/defination
- All names of the Resources should be defined as per Eurofins standard naming conventions.

- While declaring variables with data type 'map(object)' or 'object; or 'list(object)', It's mandatory to define all the attributes in object. If you don't want to set any attribute then define its value as null or empty list([]) or empty map({}) as per the object data type.

- Please make sure all the Required paramaters are set. Refer below section to understand the required and optional input values when using this module.

- Please verify that the values provided to the variables are in comfort with the allowed values for that variable. Refer below section to understand the allowed values for each variable when using this module.

