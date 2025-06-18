# Corp Landing Zone Configuration

# Global Settings
location = "Canada Central"

# Subscription IDs
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"

# Corp Landing Zone Resources
corp_network_rg_name    = "rg-corp-network"
corp_app_rg_name        = "rg-corp-app"
corp_vnet_name          = "vnet-corp-prod-01"
corp_vnet_address_space = ["10.20.0.0/16"]
corp_vnet_dns_servers   = ["10.0.2.4", "10.0.2.5"] # Domain controllers in platform subnet

# Corp Subnets
corp_subnets = {
  "snet-corp-vm"   = ["10.20.1.0/24"]
  "snet-corp-data" = ["10.20.2.0/24"]
  "GatewaySubnet"  = ["10.20.0.0/27"]
}

# Corp VMs
vm_count       = 2
vm_size        = "Standard_B2s"
admin_username = "azadmin"
admin_password = "P@ssw0rd123!" # In production, use Azure Key Vault or another secure method

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