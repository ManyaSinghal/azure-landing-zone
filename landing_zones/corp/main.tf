

# Corp Landing Zone Module - New module implementation
module "corp_landing_zone" {
  source = "../../Modules/corp-landing-zone"
  # Core variables
  location                = var.location
  corp_network_rg_name    = var.corp_network_rg_name
  corp_app_rg_name        = var.corp_app_rg_name
  corp_vnet_name          = var.corp_vnet_name
  corp_vnet_address_space = var.corp_vnet_address_space
  corp_vnet_dns_servers   = var.corp_vnet_dns_servers
  corp_subnets            = var.corp_subnets

  # VM configuration
  vm_count       = var.vm_count
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password

  # Required attributes from platform modules
  firewall_private_ip        = data.azurerm_firewall.platform_firewall.ip_configuration[0].private_ip_address
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.platform_law.id
}

# VNet Peering Module - New module implementation
module "vnet_peering" {
  source = "../../Modules/vnet-peering"
  count  = var.deploy_vnet_peering ? 1 : 0
  depends_on = [
    module.corp_landing_zone
  ]
  providers = {
    azurerm       = azurerm.platform
    azurerm.spoke = azurerm
  }

  hub_vnet_name           = var.platform_vnet_name
  hub_vnet_id             = data.azurerm_virtual_network.platform_vnet.id
  hub_resource_group_name = var.platform_connectivity_rg_name

  spoke_vnet_name           = var.corp_vnet_name
  spoke_vnet_id             = module.corp_landing_zone.vnet_id
  spoke_resource_group_name = var.corp_network_rg_name

  use_hub_gateway = true
}
