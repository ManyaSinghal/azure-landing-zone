resource "azurerm_resource_group" "platform_connectivity" {
  name     = var.platform_connectivity_rg_name
  location = var.location
  tags = {
    CostCenter = lookup(var.platform_vnet_tags, "CostCenter", "None")
    Env        = lookup(var.platform_vnet_tags, "Env", "Prod")
  }
}

# Create the Virtual Network
resource "azurerm_virtual_network" "platform_vnet" {
  name                = var.platform_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_connectivity.name
  address_space       = var.platform_vnet_address_space
  dns_servers         = var.platform_vnet_dns_servers
  tags                = var.platform_vnet_tags
}

# Create Subnets
resource "azurerm_subnet" "platform_subnets" {
  for_each             = var.platform_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.platform_connectivity.name
  virtual_network_name = azurerm_virtual_network.platform_vnet.name
  address_prefixes     = each.value
}

# Create NSGs for each subnet (except special subnets)
resource "azurerm_network_security_group" "platform_nsgs" {
  for_each            = { for k, v in var.platform_subnets : k => v if k != "GatewaySubnet" && k != "AzureFirewallSubnet" }
  name                = "NSG-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_connectivity.name
  tags                = var.platform_vnet_tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "platform_nsg_associations" {
  for_each                  = { for k, v in var.platform_subnets : k => v if k != "GatewaySubnet" && k != "AzureFirewallSubnet" }
  subnet_id                 = azurerm_subnet.platform_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.platform_nsgs[each.key].id
}

# Azure Firewall
resource "azurerm_public_ip" "fw_pip" {
  count               = var.deploy_azure_firewall ? 1 : 0
  name                = "pip-${var.azure_firewall_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.azure_firewall_tags
}

resource "azurerm_firewall" "platform_firewall" {
  count               = var.deploy_azure_firewall ? 1 : 0
  name                = var.azure_firewall_name
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_connectivity.name
  sku_name            = var.azure_firewall_sku_name
  sku_tier            = var.azure_firewall_sku_tier
  tags                = var.azure_firewall_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.platform_subnets["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.fw_pip[0].id
  }
}

# Route table for traffic via firewall
resource "azurerm_route_table" "fw_route_table" {
  count               = var.deploy_azure_firewall ? 1 : 0
  name                = "rt-${var.platform_vnet_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.platform_connectivity.name
  tags                = var.platform_vnet_tags

  route {
    name                   = "to-internet-via-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.platform_firewall[0].ip_configuration[0].private_ip_address
  }
}

# Hub-to-Spoke VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count                        = var.deploy_vnet_peering && length(var.spoke_vnet_ids) > 0 ? length(var.spoke_vnet_ids) : 0
  name                         = "peer-hub-to-spoke-${count.index}"
  resource_group_name          = azurerm_resource_group.platform_connectivity.name
  virtual_network_name         = azurerm_virtual_network.platform_vnet.name
  remote_virtual_network_id    = var.spoke_vnet_ids[count.index]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}