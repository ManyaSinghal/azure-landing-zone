# Landing Zone Standard Policies

# Management Groups creation and association with Subscription ids.
module "managementgroups" {
  source                                          = "../../Modules/managementgroups"
  count                                           = var.deploy_managementgroups ? 1 : 0
  mainmanagement_group1_display_name              = var.mainmanagement_group1_display_name
  management_group1_display_name                  = var.management_group1_display_name
  management_group1_subscription_ids              = var.management_group1_subscription_ids
  management_group2_display_name                  = var.management_group2_display_name
  management_group2_subscription_ids              = var.management_group2_subscription_ids
  management_group2a_display_name                 = var.management_group2a_display_name
  management_group2a_subscription_ids             = var.management_group2a_subscription_ids
  management_group2b_display_name                 = var.management_group2b_display_name
  management_group2b_subscription_ids             = var.management_group2b_subscription_ids
  management_group3_display_name                  = var.management_group3_display_name
  management_group3_subscription_ids              = var.management_group3_subscription_ids
  management_group4_display_name                  = var.management_group4_display_name
  management_group4_subscription_ids              = var.management_group4_subscription_ids
  mainmanagement_group_users_for_owner_role       = var.mainmanagement_group_users_for_owner_role
  mainmanagement_group_users_for_reader_role      = var.mainmanagement_group_users_for_reader_role
  mainmanagement_group_usergroups_for_owner_role  = var.mainmanagement_group_usergroups_for_owner_role
  mainmanagement_group_usergroups_for_reader_role = var.mainmanagement_group_usergroups_for_reader_role
}

# Policies Module - Moved up in the execution order
module "Policies" {
  source                                     = "../../Modules/Policies"
  count                                      = var.deploy_policies ? 1 : 0
  depends_on                                 = [module.managementgroups]
  company_name                               = var.company_name
  location                                   = var.location
  mainmanagement_group1_display_name         = var.mainmanagement_group1_display_name
  networkwatcher_rg                          = var.networkwatcher_rg
  networkwatcher_locations                   = var.networkwatcher_locations
  policy_allowed_regions_enable              = var.policy_allowed_regions_enable
  policy_allowed_regions_list                = var.policy_allowed_regions_list
  policy_allowed_storage_skus_enable         = var.policy_allowed_storage_skus_enable
  policy_allowed_storage_skus_list           = var.policy_allowed_storage_skus_list
  policy_allowed_vm_skus_enable              = var.policy_allowed_vm_skus_enable
  policy_allowed_vm_skus_list                = var.policy_allowed_vm_skus_list
  policy_deny_ip_forwarding_enable           = var.policy_deny_ip_forwarding_enable
  policy_prevent_inbound_rdp_enable          = var.policy_prevent_inbound_rdp_enable
  policy_associate_with_nsg_enable           = var.policy_associate_with_nsg_enable
  policy_networkwatcher_enabled_audit_enable = var.policy_networkwatcher_enabled_audit_enable
  policy_networkwatcher_deploy_enable        = var.policy_networkwatcher_deploy_enable
  policy_https_to_storage_enable             = var.policy_https_to_storage_enable
  policy_sql_encryption_enable               = var.policy_sql_encryption_enable
  policy_invalid_resource_types_enable       = var.policy_invalid_resource_types_enable
  policy_invalid_resource_types_list         = var.policy_invalid_resource_types_list
  policy_security_center_deploy_enable       = var.policy_security_center_deploy_enable
  policy_inherit_sub_tags                    = var.policy_inherit_sub_tags
  policy_asc_monitoring_enable               = var.policy_asc_monitoring_enable
  policy_enforce_inguest_monitoring_enable   = var.policy_enforce_inguest_monitoring_enable
  policy_enforce_vm_backup_enable            = var.policy_enforce_vm_backup_enable
  policy_audit_diagnostics_enable            = var.policy_audit_diagnostics_enable
  policy_audit_diagnostics_types_list        = var.policy_audit_diagnostics_types_list
  policy_audit_sqlservers_enable             = var.policy_audit_sqlservers_enable
  policy_required_rg_tags                    = var.policy_required_rg_tags
  policy_inherit_rg_tags                     = var.policy_inherit_rg_tags
}

# Additional Resource Groups Deployment
module "resourcegroups" {
  depends_on                 = [module.Policies]
  source                     = "../../Modules/resourcegroups"
  count                      = var.deploy_additionalresourcegroups ? 1 : 0
  additional_resource_groups = var.additional_resource_groups
}

# Platform Management Module Deployment
module "platform_management" {
  source     = "../../Modules/platform-management"
  count      = var.deploy_platform_management ? 1 : 0
  depends_on = [module.Policies, module.resourcegroups]

  location                     = var.location
  platform_management_rg_name  = var.platform_management_rg_name
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_retention_days = var.log_analytics_retention_days
  automation_account_name      = var.automation_account_name
  sentinel_enabled             = var.sentinel_enabled
}

# Platform Connectivity Module Deployment
module "platform_connectivity" {
  source     = "../../Modules/platform-connectivity"
  count      = var.deploy_platform_connectivity ? 1 : 0
  depends_on = [module.Policies, module.resourcegroups]

  location                      = var.location
  platform_connectivity_rg_name = var.platform_connectivity_rg_name
  platform_vnet_name            = var.platform_vnet_name
  platform_vnet_address_space   = var.platform_vnet_address_space
  platform_vnet_dns_servers     = var.platform_vnet_dns_servers
  platform_vnet_tags            = var.platform_vnet_tags
  platform_subnets              = var.platform_subnets

  deploy_azure_firewall   = var.deploy_azure_firewall
  azure_firewall_name     = var.azure_firewall_name
  azure_firewall_sku_tier = var.azure_firewall_sku_tier
  azure_firewall_sku_name = var.azure_firewall_sku_name
  azure_firewall_tags     = var.azure_firewall_tags

  # Optional VNet peering configuration - Will be done separately via the vnet_peering module
  deploy_vnet_peering = false
  spoke_vnet_ids      = []
}

# Platform Identity Module - New implementation that uses platform subnet
# Platform Identity Module - Fixed to match existing variables
module "platform_identity" {
  source = "../../Modules/identity" # Use existing identity module
  count  = var.deploy_identity ? 1 : 0
  depends_on = [
    module.platform_connectivity,
    module.Policies,
    module.platform_management
  ]

  location                               = var.location
  ident_rg_name                          = var.ident_rg_name
  ident_dcstore_bootdiag_name            = var.ident_dcstore_bootdiag_name
  ident_keyvault_name                    = var.ident_keyvault_name
  ident_recoveryservicesvault_name       = var.ident_recoveryservicesvault_name
  ident_recoveryservicesvault_softdelete = var.ident_recoveryservicesvault_softdelete
  ident_dcavailset_name                  = var.ident_dcavailset_name
  ident_dcavailset_fault_domain_count    = var.ident_dcavailset_fault_domain_count

  # Use the platform management subnet ID if landingzone is not deployed
  ident_dc_subnet_id = var.deploy_lzvirtualnetwork ? data.azurerm_subnet.dc_subnet[0].id : module.platform_connectivity[0].subnet_ids["snet-platform-mgmt"]

  ident_dc_admin_username          = var.ident_dc_admin_username
  ident_dc_admin_password          = var.ident_dc_admin_password
  ident_dc01_nic_name              = var.ident_dc01_nic_name
  ident_dc02_nic_name              = var.ident_dc02_nic_name
  ident_dc01_nic_ip                = var.ident_dc01_nic_ip
  ident_dc02_nic_ip                = var.ident_dc02_nic_ip
  ident_dc01_name                  = var.ident_dc01_name
  ident_dc01_size                  = var.ident_dc01_size
  ident_dc02_name                  = var.ident_dc02_name
  ident_dc02_size                  = var.ident_dc02_size
  ident_backup_policy_name         = var.ident_backup_policy_name
  ident_dcstore_bootdiag_tags      = var.ident_dcstore_bootdiag_tags
  ident_keyvault_tags              = var.ident_keyvault_tags
  ident_recoveryservicesvault_tags = var.ident_recoveryservicesvault_tags
  ident_dc_count                   = var.ident_dc_count
}

# Legacy Landing Zone Network Module - Keep for backward compatibility
module "landingzone_virtual_network" {
  depends_on                     = [module.Policies, module.platform_connectivity]
  source                         = "../../Modules/landingzone-virtual-network"
  count                          = var.deploy_lzvirtualnetwork ? 1 : 0
  location                       = var.location
  resource_group_name            = var.network_rg_name
  landingzone_vnet_name          = var.landingzone_vnet_name
  landingzone_vnet_address_space = var.landingzone_vnet_address_space
  landingzone_vnet_dns_servers   = var.landingzone_vnet_dns_servers
  landingzone_subnets            = var.landingzone_subnets
  landingzone_NSG_Prefix         = var.landingzone_NSG_Prefix
  landingzone_vnet_tags          = var.landingzone_vnet_tags
}

# Gateway Subnet reference for legacy VPN/ExpressRoute
data "azurerm_subnet" "GatewaySubnet" {
  count                = var.deploy_vpn_gateway && var.deploy_platform_connectivity ? 1 : 0
  name                 = "GatewaySubnet"
  virtual_network_name = var.platform_vnet_name
  resource_group_name  = var.platform_connectivity_rg_name
  depends_on = [
    module.platform_connectivity
  ]
}

# VPN Gateway Module - Updated to use platform subnet
module "vpn_gateway" {
  depends_on = [
    data.azurerm_subnet.GatewaySubnet,
    module.Policies,
    module.platform_connectivity
  ]
  source                               = "../../Modules/vpngateway"
  count                                = var.deploy_vpn_gateway && contains(var.vpn_gateway_type, "vpn") ? 1 : 0
  gtwy_vpn_name                        = var.gtwy_vpn_name
  gtwy_subnet_object                   = data.azurerm_subnet.GatewaySubnet[0]
  gtwy_local_address                   = var.gtwy_local_address
  gtwy_local_address_spaces            = var.gtwy_local_address_spaces
  gtwy_connection_private_key          = var.gtwy_connection_private_key
  gtwy_vpn_sku                         = var.gtwy_vpn_sku
  deploy_local_network_gtwy_connection = var.deploy_local_network_gtwy_connection
  gtyw_vpn_generation                  = var.gtyw_vpn_generation
  gtwy_vpn_tags                        = var.gtwy_vpn_tags
  gtwy_local_tags                      = var.gtwy_local_tags
}

# ExpressRoute Module - Updated to use platform subnet
module "express_route" {
  depends_on = [
    data.azurerm_subnet.GatewaySubnet,
    module.Policies,
    module.platform_connectivity
  ]

  source = "../../Modules/expressroute"
  count  = var.deploy_vpn_gateway && contains(var.vpn_gateway_type, "expressroute") ? 1 : 0

  expressroute_vpn_gtwy_name            = var.expressroute_vpn_gtwy_name
  gtwy_subnet_object                    = data.azurerm_subnet.GatewaySubnet[0]
  expressroute_circuit_name             = var.expressroute_circuit_name
  expressroute_circuit_service_provider = var.expressroute_circuit_service_provider
  expressroute_circuit_peering_location = var.expressroute_circuit_peering_location
  expressroute_circuit_bandwidth        = var.expressroute_circuit_bandwidth
  expressroute_circuit_sku              = var.expressroute_circuit_sku
  expressroute_circuit_family           = var.expressroute_circuit_family
  expressroute_circuit_tags             = var.expressroute_circuit_tags
  expressroute_gtwy_vpn_tags            = var.expressroute_gtwy_vpn_tags
}