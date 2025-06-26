## Platform network resources

module "platform_virtual_network" {
  source               = "../../Modules/AzureNetwork/virtual_network"
  for_each             = var.platform_virtual_network
  virtual_network_name = each.value["virtual_network_name"]
  location             = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name  = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  vnet_address_space   = each.value["vnet_address_space"]
  dns_servers          = each.value["dns_servers"]
  vnet_tags            = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
}

module "platform_subnets" {
  source                        = "../../Modules/AzureNetwork/subnet"
  for_each                      = var.platform_subnets
  subnet_name                   = each.value["subnet_name"]
  resource_group_name           = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  subnet_address_prefix         = each.value["subnet_address_prefix"]
  virtual_network_name          = module.platform_virtual_network["${each.value["vnet_key"]}"].az_virtual_network_name
  create_subnet_nsg_association = each.value["create_subnet_nsg_association"]
  network_security_group_id     = each.value["create_subnet_nsg_association"] ? module.platform_nsg["${each.value["nsg_key"]}"].az_network_security_group_id : null
}

module "platform_nsg" {
  source              = "../../Modules/AzureNetwork/network_security_group"
  for_each            = var.platform_nsg
  security_group_name = each.value["security_group_name"]
  location            = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  nsg_tags            = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  nsg_rules           = each.value["nsg_rules"]
}

module "platform_firewall" {
  source                   = "../../Modules/AzureNetwork/AzureFirewall"
  azure_firewall_name      = var.azure_firewall_name
  azure_firewall_sku_tier  = "Standard"
  azure_firewall_sku_name  = "AZFW_VNet"
  firewall_additional_tags = module.platform_rgs["rg2"].az_resource_group_tags
  resource_group_name      = module.platform_rgs["rg2"].az_resource_group_name
  subnet_id                = "/subscriptions/b8e8b895-9267-4bf3-9ea4-9b3fd73d9064/resourceGroups/${module.platform_rgs["rg2"].az_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.platform_virtual_network["vnet1"].az_virtual_network_name}/subnets/${module.platform_subnets["snet4"].az_subnet_name}"
  ip_config_name           = "${var.azure_firewall_name}-ipconfig"
  fw_network_rules         = {}
  fw_application_rules     = {}
  fw_nat_rules             = {}
  depends_on               = [module.platform_virtual_network, module.platform_subnets, module.platform_rgs]
}

module "platform_route_table" {
  source              = "../../Modules/AzureNetwork/route_table"
  route_table_name    = var.route_table_name
  location            = module.platform_rgs["rg2"].az_resource_group_location
  resource_group_name = module.platform_rgs["rg2"].az_resource_group_name
  route_table_tags    = module.platform_rgs["rg2"].az_resource_group_tags
  routes = {
    rt1 = {
      name                   = "to-internet-via-fw"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.platform_firewall.firewall_private_ips
    }
  }
  create_route_filter = false
}

module "platyform_express_route_circuit" {
  source                                = "../../Modules/AzureNetwork/express_route"
  expressroute_circuit_name             = var.expressroute_circuit_name
  location                              = module.platform_rgs["rg2"].az_resource_group_location
  resource_group_name                   = module.platform_rgs["rg2"].az_resource_group_name
  expressroute_circuit_tags             = module.platform_rgs["rg2"].az_resource_group_tags
  expressroute_circuit_service_provider = "Equinix"
  expressroute_circuit_peering_location = "Silicon Valley"
  expressroute_circuit_bandwidth        = 50
  expressroute_circuit_sku              = "Standard"
  expressroute_circuit_family           = "MeteredData"
}

module "vnet_gw" {
  source                    = "../../Modules/AzureNetwork/vpn_gateway"
  for_each                  = var.vnet_gws
  location                  = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name       = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  vnet_gw_tags              = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  vnet_gw_type              = each.value["vnet_gw_type"]
  vnet_gw_name              = each.value["vnet_gw_name"]
  vnet_gw_snet_id           = module.platform_subnets["${each.value["snet_key"]}"].az_subnet_id
  vnet_gw_sku               = each.value["vnet_gw_sku"]
  vnet_gw_generation        = each.value["vnet_gw_generation"]
  create_local_nw_gw        = each.value["create_local_nw_gw"]
  local_gw_address_spaces   = each.value["create_local_nw_gw"] ? lookup(each.value, "local_gw_address_spaces", null) : null
  local_gw_name             = each.value["create_local_nw_gw"] ? lookup(each.value, "local_gw_name", null) : null
  local_gw_address          = each.value["create_local_nw_gw"] ? lookup(each.value, "local_gw_address", null) : null
  gw_connection_private_key = each.value["create_local_nw_gw"] ? lookup(each.value, "gw_connection_private_key", null) : null
}

# VNet Peering Module - New module implementation
module "vnet_peering" {
  source = "../../Modules/AzureNetwork/virtual_network_peering"
  providers = {
    azurerm.dst = azurerm
  }
  virtual_network_dest_name    = module.platform_virtual_network["vnet1"].az_virtual_network_name
  virtual_network_dest_id      = module.platform_virtual_network["vnet1"].az_virtual_network_id
  virtual_network_dest_rg_name = module.platform_rgs["rg2"].az_resource_group_name

  virtual_network_src_name    = module.platform_virtual_network["vnet2"].az_virtual_network_name
  virtual_network_src_id      = module.platform_virtual_network["vnet2"].az_virtual_network_id
  virtual_network_src_rg_name = module.platform_rgs["rg3"].az_resource_group_name

  use_remote_src_gateway  = true
  use_remote_dest_gateway = true
}
