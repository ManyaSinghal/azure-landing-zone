# Corp Landing Zone Configuration

# Global Settings

# Subscription IDs
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064" # Replace with your actual platform subscription ID
corp_subscription_id     = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064" # Replace with your actual corp subscription ID

#Platform Management Resources
platform_management_rg_name  = "TreyResearch-mgmt"
log_analytics_workspace_name = "log-treyresearch-prod-001"

#Platform Connectivity Resources
platform_connectivity_rg_name = "TreyResearch-Connectivity"
platform_vnet_name            = "vnet-platform-prod-01"
platform_azure_firewall_name  = "fw-platform-prod-01"



# Corp Landing Zone Resources
route_table_name = "rt-vnet-corp-prod-01"
# VNet Peering
deploy_vnet_peering = true

resource_groups = {
  rg1 = {
    resource_group_name = "rg-corp-network"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg2 = {
    resource_group_name = "rg-corp-app"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
}

corp_virtual_network = {
  vnet1 = {
    virtual_network_name = "vnet-corp-prod-01"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    rg_key               = "rg1"
    vnet_address_space   = ["10.20.0.0/16"]
  }
}

# Corp Subnets
corp_subnets = {
  snet1 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.1.0/24"]
    subnet_name                          = "snet-corp-vm"
    create_subnet_nsg_association        = true
    nsg_key                              = "nsg1"
    create_subnet_routetable_association = true
  }
  snet2 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.2.0/24"]
    subnet_name                          = "snet-corp-data"
    create_subnet_nsg_association        = true
    nsg_key                              = "nsg1"
    create_subnet_routetable_association = true
  }
  snet3 = {
    vnet_key                             = "vnet1"
    rg_key                               = "rg1"
    subnet_address_prefix                = ["10.20.0.0/27"]
    subnet_name                          = "GatewaySubnet"
    create_subnet_nsg_association        = false
    nsg_key                              = null
    create_subnet_routetable_association = true
  }

}

corp_nsg = {
  nsg1 = {
    security_group_name = "corp_nsg"
    rg_key              = "rg1"
    nsg_rules           = []
  }
}


# Corp VMs
admin_username = "azadmin"
admin_password = "P@ssw0rd123!" # In production, use Azure Key Vault or another secure method
corp_nics = {
  nic1 = {
    nic_name = "nic-corp-vm--001"
    rg_key   = "rg2"
    snet_key = "snet"
  }
  nic2 = {
    nic_name           = "nic-ident-prod-002"
    rg_key             = "rg2"
    snet_key           = "snet1"
    private_ip_address = "10.15.1.5"
  }
}

corp_vms = {
  vm1 = {
    windows_vm_name = "vm-corp-01"
    windows_vm_size = "Standard_B2s"
    nic_key         = "nic1"
    rg_key          = "rg2"
    storage_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  }
  vm2 = {
    windows_vm_name = "vm-corp-02"
    windows_vm_size = "Standard_B2s"
    nic_key         = "nic2"
    rg_key          = "rg2"
    storage_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  }
}
