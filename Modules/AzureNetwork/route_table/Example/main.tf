module "route_table" {
  source                        = "../modules/azurerm/AzureNetwork/route_table"
  route_table_name              = var.route_table_name
  location                      = module.rg.az_resource_group_location
  resource_group_name           = module.rg.az_resource_group_name
  tags                          = var.tags
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  routes                        = var.route
  create_route_filter           = var.create_route_filter
}
