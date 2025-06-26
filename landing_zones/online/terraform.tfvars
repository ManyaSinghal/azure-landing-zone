# online Landing Zone Configuration

# Global Settings

# Subscription IDs
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064" # Replace with your actual platform subscription ID
online_subscription_id   = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064" # Replace with your actual online subscription ID
environment              = "prod"
#Platform Management Resources
platform_management_rg_name  = "TreyResearch-mgmt"
log_analytics_workspace_name = "log-treyresearch-prod-001"

#Platform Connectivity Resources
platform_connectivity_rg_name = "TreyResearch-Connectivity"
platform_vnet_name            = "vnet-platform-prod-01"
platform_azure_firewall_name  = "fw-platform-prod-001"



# online Landing Zone Resources
route_table_name = "rt-vnet-online-prod-01"
# VNet Peering
deploy_vnet_peering = true

resource_groups = {
  rg1 = {
    resource_group_name = "rg-online-network"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg2 = {
    resource_group_name = "rg-online-app"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
}

online_virtual_network = {
  vnet1 = {
    virtual_network_name = "vnet-online-prod-01"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    rg_key               = "rg1"
    vnet_address_space   = ["10.20.0.0/16"]
  }
}

# online Subnets
online_subnets = {
  snet1 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.1.0/24"]
    subnet_name                          = "snet-online-vm"
    create_subnet_nsg_association        = true
    nsg_key                              = "nsg1"
    create_subnet_routetable_association = true
  }
  snet2 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.2.0/24"]
    subnet_name                          = "snet-online-data"
    create_subnet_nsg_association        = true
    nsg_key                              = "nsg1"
    create_subnet_routetable_association = true
  }
  snet3 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.0.0/27"]
    subnet_name                          = "AppGatewaySubnet"
    create_subnet_nsg_association        = false
    nsg_key                              = null
    create_subnet_routetable_association = true
  }

}

online_nsg = {
  nsg1 = {
    security_group_name = "online_nsg"
    rg_key              = "rg1"
    nsg_rules           = []
  }
}


# online VMs
admin_username = "azadmin"
admin_password = "P@ssw0rd123!" # In production, use Azure Key Vault or another secure method

app_service_plan_name = ""
app_service_name      = ""