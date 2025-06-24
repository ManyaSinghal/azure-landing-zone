module "virtual_network" {
  source               = "../modules/azurerm/AzureNetwork/virtual_network"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = module.rg.az_resource_group_name
  vnet_address_space   = var.vnet_address_space
  dns_servers          = var.dns_servers
  ddos_plan_name       = var.ddos_plan_name
  vnet_tags            = var.vnet_tags
}
