# -
# - Azure app service plan
# -
resource "azurerm_app_service_plan" "az_app_service_plan" {
  name                         = var.app_service_plan_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  kind                         = var.app_service_plan_kind
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  app_service_environment_id   = var.app_service_environment_id
  reserved                     = var.app_service_plan_reserved
  per_site_scaling             = var.per_site_scaling
  tags                         = var.app_service_plan_tags

  # sku config block
  sku {
    tier     = var.app_service_plan_sku.tier
    size     = var.app_service_plan_sku.size
    capacity = var.app_service_plan_sku.capacity
  }
}
