module "subnet" {
  source                        = "../modules/azurerm/AzureNetwork/subnet"
  subnet_name                   = var.subnet_name
  resource_group_name           = module.rg.az_resource_group_name
  virtual_network_name          = module.vnet.az_virtual_network_name
  subnet_address_prefix         = var.subnet_address_prefix
  service_endpoints             = var.service_endpoints
  subnet_delegation             = var.subnet_delegation
  subnet_nsg_association        = var.subnet_nsg_association
  subnet_routetable_association = var.subnet_routetable_association
}
