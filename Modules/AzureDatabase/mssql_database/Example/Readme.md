# Create mssql database in Azure
This Module allows you to create and manage one or multiple mssql database in Microsoft Azure.

## Features
This module will:

- Create one or muliple mssql database in Microsoft Azure.

## Usage
```hcl
module "azure_mssql_database" {
  source              = "../modules/azurerm/AzureDatabase/mssql_database"
  mssql_database_name = var.mssql_database_name
  mssql_server_id     = module.azure_mssql_server.az_mssql_server_id
  collation           = var.collation
  license_type        = var.license_type
  max_size_gb         = var.max_size_gb
  sku_name            = var.sku_name
  create_mode         = var.create_mode
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

