# Create App service plan in Azure
This Module allows you to create and manage one or multiple App service plan in Microsoft Azure.

## Features
This module will:

- Create one or muliple App service plan in Microsoft Azure.

## Usage
```hcl
module "App_service_plan" {
  source = "../modules/azurerm/Web_App_Service/App_service_plan"
  resource_group_name               = module.rg.az_resource_group_name
  location                          = module.rg.az_resource_group_location
  app_service_plan_kind             = var.app_service_plan_kind
  app_service_plan_name             = var.app_service_plan_name
  app_service_plan_sku              = var.app_service_plan_sku
  app_service_plan_tags             = var.app_service_plan_tags
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

