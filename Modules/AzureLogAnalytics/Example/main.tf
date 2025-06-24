#Example 1
module "az_log_analytics" {
  source                         = "../modules/azurerm/AzureLogAnalytics"
  prefix                         = var.prefix
  location                       = module.rg.az_resource_group_location
  resource_group_name            = module.rg.az_resource_group_name
  log_analytics_workspace_sku    = var.log_analytics_workspace_sku
  tags                           = var.tags
  log_solution_name              = var.log_solution_name
  plan                           = var.plan
  enable_log_analytics_workspace = var.enable_log_analytics_workspace
}


