
resource "azurerm_express_route_circuit" "expressroute_circuit" {
  name                  = var.expressroute_circuit_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = var.expressroute_circuit_service_provider
  peering_location      = var.expressroute_circuit_peering_location
  bandwidth_in_mbps     = var.expressroute_circuit_bandwidth

  sku {
    tier   = var.expressroute_circuit_sku
    family = var.expressroute_circuit_family
  }
  tags = var.expressroute_circuit_tags
}
