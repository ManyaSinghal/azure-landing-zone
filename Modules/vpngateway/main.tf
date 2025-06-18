data "azurerm_resource_group" "rg_gtwy" {
  name = var.gtwy_subnet_object.resource_group_name
}

resource "azurerm_public_ip" "pub_ip" {
  name                = var.gtwy_pub_ip_name
  location            = data.azurerm_resource_group.rg_gtwy.location
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "vpngtwy" {
  name                = var.gtwy_vpn_name
  location            = data.azurerm_resource_group.rg_gtwy.location
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name

  type     = "Vpn"
  vpn_type = var.gtwy_vpn_type

  active_active = var.gtwy_vpn_active_active
  enable_bgp    = var.gtwy_vpn_enable_bgp
  sku           = var.gtwy_vpn_sku
  generation    = var.gtyw_vpn_generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pub_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gtwy_subnet_object.id
  }

  tags = var.gtwy_vpn_tags
}

resource "azurerm_local_network_gateway" "localgtwy" {
  count               = var.deploy_local_network_gtwy_connection ? 1 : 0
  name                = var.gtwy_local_name
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name
  location            = data.azurerm_resource_group.rg_gtwy.location
  gateway_address     = var.gtwy_local_address
  address_space       = var.gtwy_local_address_spaces
  tags                = var.gtwy_local_tags
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  count               = var.deploy_local_network_gtwy_connection ? 1 : 0
  name                = var.gtwy_connection_name
  location            = data.azurerm_resource_group.rg_gtwy.location
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngtwy.id
  local_network_gateway_id   = azurerm_local_network_gateway.localgtwy[0].id

  shared_key = var.gtwy_connection_private_key
}
