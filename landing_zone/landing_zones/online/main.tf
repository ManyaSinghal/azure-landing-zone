# Online Landing Zone Module - New module implementation
module "online_landing_zone" {
  source                     = "../../Modules/online-landing-zone"
  location                   = var.location
  online_network_rg_name     = var.online_network_rg_name
  online_app_rg_name         = var.online_app_rg_name
  online_vnet_name           = var.online_vnet_name
  online_vnet_address_space  = var.online_vnet_address_space
  online_vnet_dns_servers    = var.online_vnet_dns_servers
  online_subnets             = var.online_subnets
  vnet_tags                  = var.landingzone_vnet_tags
  firewall_private_ip        = data.azurerm_firewall.platform_firewall.ip_configuration[0].private_ip_address
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.platform_law.id
  environment                = var.environment
  sql_admin_username         = var.sql_admin_username
  sql_admin_password         = var.sql_admin_password
}

# VNet Peering Module - New module implementation
module "vnet_peering" {
  source = "../../Modules/vnet-peering"
  count  = var.deploy_vnet_peering ? 1 : 0
  depends_on = [
    module.online_landing_zone
  ]
  providers = {
    azurerm       = azurerm.platform
    azurerm.spoke = azurerm
  }

  hub_vnet_name           = var.platform_vnet_name
  hub_vnet_id             = data.azurerm_virtual_network.platform_vnet.id
  hub_resource_group_name = var.platform_connectivity_rg_name

  spoke_vnet_name           = var.online_vnet_name
  spoke_vnet_id             = module.online_landing_zone.vnet_id
  spoke_resource_group_name = var.online_network_rg_name

  use_hub_gateway = true
}
