
module "azure_storage" {
  source               = "../modules/azurerm/AzureStorage/storage_account"
  storage_account_name = var.storage_account_name
  location             = module.rg.az_resource_group_location
  resource_group_name  = module.rg.az_resource_group_name
  account_kind         = var.account_kind
  account_tier         = var.account_tier
  network_rules = [
    {
      default_action             = "Allow"
      virtual_network_subnet_ids = module.subnet.az_subnet_id
    }
  ]
  tags = var.tags
}
