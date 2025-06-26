resource_groups = {
  rg1 = {
    resource_group_name = "TreyResearch-mgmt"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg2 = {
    resource_group_name = "TreyResearch-connectivity"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg3 = {
    resource_group_name = "TreyResearch-identity"
    location            = "Canada Central" #Target LZ region
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
}

log_analytics_workspace = "log-treyresearch-prod-001"
automation_account_name = "auto-treyresearch-prod-001"

platform_virtual_network = {
  vnet1 = {
    virtual_network_name = "vnet-platform-prod-01"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    rg_key               = "rg2"
    vnet_address_space   = ["10.0.0.0/16"]
  }
  vnet2 = {
    virtual_network_name = "vnet-prod-usw-01"
    rg_key               = "rg3"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    vnet_address_space   = ["10.15.0.0/16"]
  }
}

platform_subnets = {
  snet1 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.1.0/24"]
    subnet_name                   = "snet-platform-connectivity"
    create_subnet_nsg_association = true
    nsg_key                       = "nsg1"
  }
  snet2 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.2.0/24"]
    subnet_name                   = "snet-platform-mgmt"
    create_subnet_nsg_association = true
    nsg_key                       = "nsg1"
  }
  snet3 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.0.0/27"]
    subnet_name                   = "GatewaySubnet"
    create_subnet_nsg_association = false
    nsg_key                       = null
  }
  snet4 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.0.64/26"]
    subnet_name                   = "AzureFirewallSubnet"
    create_subnet_nsg_association = false
    nsg_key                       = null
  }
  snet5 = {
    vnet_key                      = "vnet2"
    rg_key                        = "rg3"
    subnet_address_prefix         = ["10.15.1.0/24"]
    subnet_name                   = "snet-prod-usw-dc"
    create_subnet_nsg_association = true
    nsg_key                       = "nsg2"
  }
  snet6 = {
    vnet_key                      = "vnet2"
    rg_key                        = "rg3"
    subnet_address_prefix         = ["10.15.2.0/24"]
    subnet_name                   = "snet-prod-usw-vm"
    create_subnet_nsg_association = true
    nsg_key                       = "nsg2"
  }
  snet7 = {
    vnet_key                      = "vnet2"
    rg_key                        = "rg3"
    subnet_address_prefix         = ["10.15.1.0/24"]
    subnet_name                   = "snet-prod-usw-dc"
    create_subnet_nsg_association = true
    nsg_key                       = "nsg2"
  }
  snet8 = {
    vnet_key                      = "vnet2"
    rg_key                        = "rg3"
    subnet_address_prefix         = ["10.15.0.0/27"]
    subnet_name                   = "GatewaySubnet"
    create_subnet_nsg_association = false
    nsg_key                       = null
  }
}

platform_nsg = {
  nsg1 = {
    security_group_name = "platform_nsg"
    rg_key              = "rg2"
    nsg_rules           = []
  }
  nsg2 = {
    security_group_name = "usw_nsg"
    rg_key              = "rg3"
    nsg_rules           = []
  }
}

azure_firewall_name       = "fw-platform-prod-01"
route_table_name          = "rt-vnet-platform-prod-01"
expressroute_circuit_name = "prod-az-ExpressRoute"

vnet_gws = {
  vgw1 = {
    rg_key             = "rg2"
    vnet_gw_type       = "RouteBased"
    vnet_gw_name       = "vgw-prod-usw-vpn"
    snet_key           = "snet3"
    vnet_gw_sku        = "VpnGw1"
    vnet_gw_generation = "Generation1"
    create_local_nw_gw = false
  }
  # vgw2 = {
  #   rg_key                          = "rg2"
  #   vnet_gw_type = "expressroute"
  #   vnet_gw_name = "vgw-platform-expressroute"
  #   vnet_gw_snet_id = "snet3"
  #   vnet_gw_sku = "standard"
  #   vnet_gw_generation = "Generation1"
  #   create_local_nw_gw = false
  # }
}

dc_sa_name = "tfsivmbootdiag2021"
dc_kv_name = "kv-ident-prod-001"
dc_nics = {
  nic1 = {
    nic_name           = "nic-ident-prod-001"
    rg_key             = "rg3"
    snet_key           = "snet7"
    private_ip_address = "10.15.1.4"
  }
  nic2 = {
    nic_name           = "nic-ident-prod-002"
    rg_key             = "rg3"
    snet_key           = "snet7"
    private_ip_address = "10.15.1.5"
  }
}

dc_vms = {
  vm1 = {
    windows_vm_name = "DC01"
    windows_vm_size = "Standard_B2s"
    nic_key         = "nic1"
    rg_key          = "rg3"
    disk_size_gb    = 64
    disk_lun        = 10
    storage_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  }
  vm2 = {
    windows_vm_name = "DC02"
    windows_vm_size = "Standard_B2s"
    nic_key         = "nic2"
    rg_key          = "rg3"
    disk_size_gb    = 64
    disk_lun        = 10
    storage_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  }
}

admin_username           = "azureuser"
admin_password           = "ComplexP@ssw0rd123!"
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"