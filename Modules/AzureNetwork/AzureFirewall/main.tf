
# -
# - Azure Public_IP
# -
resource "azurerm_public_ip" "this" {
  name                = "pip-${var.azure_firewall_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.firewall_additional_tags
}

# -
# - Azure firewall
# -

resource "azurerm_firewall" "az_firewall" {
  name                = var.azure_firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.azure_firewall_sku_name
  sku_tier            = var.azure_firewall_sku_tier
  tags                = var.firewall_additional_tags

  ip_configuration {
    name                 = var.ip_config_name
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}



resource "null_resource" "dependency_firewall" {
  depends_on = [azurerm_firewall.az_firewall]
}

# -
# - Azure firewall network rule collection
# -
resource "azurerm_firewall_network_rule_collection" "this" {
  for_each            = var.fw_network_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.az_firewall.name
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }

  depends_on = [azurerm_firewall.az_firewall]
}

# -
# - Azure firewall nat rule collection
# -
resource "azurerm_firewall_nat_rule_collection" "this" {
  for_each            = var.fw_nat_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.az_firewall.name
  priority            = each.value["priority"]
  action              = "Dnat"

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = list(azurerm_public_ip.this.ip_address)
      protocols             = rule.value.protocols
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }

  depends_on = [azurerm_firewall.az_firewall]
}

# -
# - Azure firewall application rule collection
# -
resource "azurerm_firewall_application_rule_collection" "this" {
  for_each            = var.fw_application_rules
  name                = each.value["name"]
  resource_group_name = var.resource_group_name
  azure_firewall_name = azurerm_firewall.az_firewall.name
  priority            = each.value["priority"]
  action              = each.value["action"]

  dynamic "rule" {
    for_each = coalesce(lookup(each.value, "rules"), [])
    content {
      name             = rule.value.name
      description      = rule.value.description
      source_addresses = rule.value.source_addresses
      fqdn_tags        = lookup(rule.value, "target_fqdns", null) == null && lookup(rule.value, "fqdn_tags", null) != null ? rule.value.fqdn_tags : []
      target_fqdns     = lookup(rule.value, "fqdn_tags", null) == null && lookup(rule.value, "target_fqdns", null) != null ? rule.value.target_fqdns : []

      dynamic "protocol" {
        for_each = lookup(rule.value, "target_fqdns", null) != null && lookup(rule.value, "fqdn_tags", null) == null ? lookup(rule.value, "protocol", []) : []
        content {
          port = lookup(protocol.value, "port", null)
          type = protocol.value.type
        }
      }
    }
  }

  depends_on = [azurerm_firewall.az_firewall]
}
