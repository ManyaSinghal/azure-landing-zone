data "azurerm_resource_group" "rg_gtwy" {
  name = var.gtwy_subnet_object.resource_group_name
}

resource "azurerm_express_route_circuit" "expressroute_circuit" {
  name                  = var.expressroute_circuit_name
  resource_group_name   = data.azurerm_resource_group.rg_gtwy.name
  location              = data.azurerm_resource_group.rg_gtwy.location
  service_provider_name = var.expressroute_circuit_service_provider
  peering_location      = var.expressroute_circuit_peering_location
  bandwidth_in_mbps     = var.expressroute_circuit_bandwidth

  sku {
    tier   = var.expressroute_circuit_sku
    family = var.expressroute_circuit_family
  }

  tags = var.expressroute_circuit_tags
}

resource "azurerm_public_ip" "pub_ip" {
  name                = var.expressroute_gtwy_pub_ip_name
  location            = data.azurerm_resource_group.rg_gtwy.location
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name

  allocation_method = "Dynamic"

  tags = var.expressroute_gtwy_pub_ip_tags
}

resource "azurerm_virtual_network_gateway" "vpngtwy" {
  name                = var.expressroute_vpn_gtwy_name
  location            = data.azurerm_resource_group.rg_gtwy.location
  resource_group_name = data.azurerm_resource_group.rg_gtwy.name

  type     = "ExpressRoute"
  vpn_type = var.expressroute_gtwy_vpn_type

  active_active = var.expressroute_gtwy_vpn_active_active
  enable_bgp    = var.expressroute_gtwy_vpn_enable_bgp
  sku           = var.expressroute_gtwy_vpn_sku
  generation    = "None"

  tags = var.expressroute_gtwy_vpn_tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pub_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gtwy_subnet_object.id
  }
}