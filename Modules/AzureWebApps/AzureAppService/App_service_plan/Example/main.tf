# Example-1
module "App_service_plan" {
  source                = "../modules/azurerm/Web_App_Service/App_service_plan"
  resource_group_name   = module.rg.az_resource_group_name
  location              = module.rg.az_resource_group_location
  app_service_plan_kind = var.app_service_plan_kind
  app_service_plan_name = var.app_service_plan_name
  app_service_plan_sku  = var.app_service_plan_sku
  app_service_plan_tags = var.app_service_plan_tags
}