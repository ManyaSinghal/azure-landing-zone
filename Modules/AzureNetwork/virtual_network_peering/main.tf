
# -
# - virtual network peering soruce
# -

resource "azurerm_virtual_network_peering" "az_vnet_peering_source" {
  name = format("%s-%s-vnp", var.virtual_network_src_name, var.virtual_network_dest_name, )

  resource_group_name          = var.virtual_network_src_rg_name
  virtual_network_name         = var.virtual_network_src_name
  remote_virtual_network_id    = var.virtual_network_dest_id
  allow_virtual_network_access = var.allow_virtual_src_network_access
  allow_forwarded_traffic      = var.allow_forwarded_src_traffic
  allow_gateway_transit        = var.allow_gateway_src_transit
  use_remote_gateways          = var.use_remote_src_gateway
}

# -
# - virtual network peering destination
# -
resource "azurerm_virtual_network_peering" "az_vnet_peering_destination" {
  provider                     = azurerm.dst
  name                         = format("%s-%s-vnp", var.virtual_network_dest_name, var.virtual_network_src_name)
  resource_group_name          = var.virtual_network_dest_rg_name
  virtual_network_name         = var.virtual_network_dest_name
  remote_virtual_network_id    = var.virtual_network_src_id
  allow_virtual_network_access = var.allow_virtual_dest_network_access
  allow_forwarded_traffic      = var.allow_forwarded_dest_traffic
  allow_gateway_transit        = var.allow_gateway_dest_transit
  use_remote_gateways          = var.use_remote_dest_gateway
}
