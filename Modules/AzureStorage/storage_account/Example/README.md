# Create Storage Accounts in Azure.

    This Module allows you to create one or multiple Storage Accounts in azure.

## Features

1.  Create one or multiple Storage Accounts in Azure.
2.  Create one or multiple containers, blobs, queues, tables and file shares in the respective Storage Account.
3.  Encrypt the Storage Account using Customer Managed key (CMK).
4.  Enable MSI identity for the created Storage Account.

## usage

```hcl
module "azure_storage" {
  source                            = "../modules/azurerm/AzureStorage/storage_account"
  storage_account_name              = var.storage_account_name
  location                          = module.rg.az_resource_group_location
  resource_group_name               = module.rg.az_resource_group_name
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  network_rules = [
    {
      default_action             = "Allow"
      virtual_network_subnet_ids = module.subnet.az_subnet_id
    }
  ]
  tags = var.tags
}
```

## Example

Please refer Example directory to consume this module into your application.

- [main.tf](./main.tf) file calls the storage account module.
- [var.tf](./var.tf) contains declaration of terraform variables which are passed to the storage account module.
- [values.auto.tfvars](./values.auto.tfvars) contains the variable defination or actual values for respective variables which are passed to the storage account module.

## Best practices for variable declarations

1.  All names of the Resources should be defined as per Eurofins standard naming conventions.
2.  While declaring variables with data type 'map(object)'. It's mandatory to define all the objects. If you don't want to use any specific objects define it as null or empty list as per the object data type.
