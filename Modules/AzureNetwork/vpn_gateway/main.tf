
resource "azurerm_public_ip" "pub_ip" {
  name                = "pip-${var.vnet_gw_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vnet_gw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Vpn"
  vpn_type            = var.vnet_gw_type

  active_active = var.vnet_gw_active_active
  enable_bgp    = var.vnet_gw_enable_bgp
  sku           = var.vnet_gw_sku
  generation    = var.vnet_gw_generation

  ip_configuration {
    name                          = "${var.vnet_gw_name}-ipconfig"
    public_ip_address_id          = azurerm_public_ip.pub_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.vnet_gw_snet_id
  }

  tags = var.vnet_gw_tags
}

resource "azurerm_local_network_gateway" "localgw" {
  count               = var.create_local_nw_gw ? 1 : 0
  name                = var.local_gw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.local_gw_address
  address_space       = var.local_gw_address_spaces
  tags                = var.vnet_gw_tags
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  count               = var.create_local_nw_gw ? 1 : 0
  name                = "${var.vnet_gw_name}-connect-to-${var.local_gw_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.localgw[0].id

  shared_key = var.gw_connection_private_key
}
