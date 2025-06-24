# -
# - Route table
# -
resource "azurerm_route_table" "az_route_table" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = var.route_table_tags
}


# -
# - Route table filter
# -
resource "azurerm_route_filter" "az_route_filter" {
  count               = var.create_route_filter ? 1 : 0
  name                = var.route_filter_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "rule" {
    for_each = var.rules
    content {
      name        = lookup(rule.value, "name", null)
      access      = lookup(rule.value, "access", null)
      rule_type   = lookup(rule.value, "rule_type", null)
      communities = [lookup(rule.value, "communities", null)]
    }
  }

}