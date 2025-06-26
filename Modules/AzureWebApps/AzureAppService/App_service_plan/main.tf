# -
# - Azure app service plan
# -
resource "azurerm_service_plan" "az_app_service_plan" {
  name                         = var.app_service_plan_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  app_service_environment_id   = var.app_service_environment_id
  tags                         = var.app_service_plan_tags
  sku_name                     = var.app_service_plan_sku
  os_type                      = var.os_type
}
