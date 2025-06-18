# Online Landing Zone Configuration

# Global Settings
location = "Canada Central"

# Subscription IDs
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"

# Online Landing Zone Resources
online_network_rg_name    = "rg-online-network"
online_app_rg_name        = "rg-online-app"
online_vnet_name          = "vnet-online-prod-01"
online_vnet_address_space = ["10.30.0.0/16"]
online_vnet_dns_servers   = ["10.0.2.4", "10.0.2.5"] # Domain controllers in platform subnet

# Online Subnets
online_subnets = {
  "snet-online-web"  = ["10.30.1.0/24"]
  "snet-online-app"  = ["10.30.2.0/24"]
  "snet-online-data" = ["10.30.3.0/24"]
  "GatewaySubnet"    = ["10.30.0.0/27"]
  "AppGatewaySubnet" = ["10.30.0.64/27"]
}

landingzone_vnet_tags = {
  CostCenter = "None"
  Env        = "Prod"
}

# SQL Server
environment        = "prod"
sql_admin_username = "sqladmin"
sql_admin_password = "P@ssw0rd123!" # In production, use Azure Key Vault or another secure method

# VNet Peering
deploy_vnet_peering = true

#Platform Management Resources
platform_management_rg_name  = "TreyResearch-mgmt"
log_analytics_workspace_name = "log-treyresearch-prod-001"

# Platform Azure Firewall
azure_firewall_name = "fw-platform-prod-01"

#Platform Connectivity Resources
platform_connectivity_rg_name = "TreyResearch-Connectivity"
platform_vnet_name            = "vnet-platform-prod-01"