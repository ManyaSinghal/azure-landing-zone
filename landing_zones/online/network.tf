module "online_virtual_network" {
  source               = "../../Modules/AzureNetwork/virtual_network"
  for_each             = var.online_virtual_network
  virtual_network_name = each.value["virtual_network_name"]
  location             = module.online_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name  = module.online_rgs["${each.value["rg_key"]}"].az_resource_group_name
  vnet_address_space   = each.value["vnet_address_space"]
  dns_servers          = each.value["dns_servers"]
  vnet_tags            = module.online_rgs["${each.value["rg_key"]}"].az_resource_group_tags
}

module "online_subnets" {
  source                               = "../../Modules/AzureNetwork/subnet"
  for_each                             = var.online_subnets
  subnet_name                          = each.value["subnet_name"]
  resource_group_name                  = module.online_rgs["${each.value["rg_key"]}"].az_resource_group_name
  subnet_address_prefix                = each.value["subnet_address_prefix"]
  virtual_network_name                 = module.online_virtual_network["${each.value["vnet_key"]}"].az_virtual_network_name
  create_subnet_nsg_association        = each.value["create_subnet_nsg_association"]
  network_security_group_id            = each.value["create_subnet_nsg_association"] ? module.online_nsg["${each.value["nsg_key"]}"].az_network_security_group_id : null
  create_subnet_routetable_association = each.value["create_subnet_routetable_association"]
  route_table_id                       = module.online_route_table.az_route_table_id
}

module "online_nsg" {
  source              = "../../Modules/AzureNetwork/network_security_group"
  for_each            = var.online_nsg
  security_group_name = each.value["security_group_name"]
  location            = module.online_rgs["rg2"].az_resource_group_location
  resource_group_name = module.online_rgs["rg2"].az_resource_group_name
  nsg_tags            = module.online_rgs["rg2"].az_resource_group_tags
  nsg_rules           = each.value["nsg_rules"]
}

module "online_route_table" {
  source              = "../../Modules/AzureNetwork/route_table"
  route_table_name    = var.route_table_name
  location           = module.online_rgs["rg2"].az_resource_group_location
  resource_group_name = module.online_rgs["rg2"].az_resource_group_name
  route_table_tags    = module.online_rgs["rg2"].az_resource_group_tags
  routes = {
    rt1 = {
      name                   = "to-hub"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = data.azurerm_firewall.platform_firewall.ip_configuration[0].private_ip_address
    }
  }
  create_route_filter = false
}

# VNet Peering Module - New module implementation
module "vnet_peering" {
  source = "../../Modules/AzureNetwork/virtual_network_peering"
  providers = {
    azurerm = azurerm.platform
    azurerm.dst = azurerm
  }

  virtual_network_src_name    = var.platform_vnet_name
  virtual_network_src_id      = data.azurerm_virtual_network.platform_vnet.id
  virtual_network_src_rg_name = var.platform_connectivity_rg_name

  virtual_network_dest_name    = module.online_virtual_network["vnet1"].az_virtual_network_name
  virtual_network_dest_id      = module.online_virtual_network["vnet1"].az_virtual_network_id
  virtual_network_dest_rg_name = module.online_rgs["rg1"].az_resource_group_name

  use_remote_src_gateway  = true
  use_remote_dest_gateway = true
}

module "app_gw" {
  source                    = "../../Modules/AzureNetwork/application_gateway"
  application_gateway_name  = "appgw-${module.online_virtual_network["vnet1"].az_virtual_network_name}"
  location                  = module.online_rgs["rg2"].az_resource_group_location
  resource_group_name       = module.online_rgs["rg2"].az_resource_group_name
  app_gateway_tags          = module.online_rgs["rg2"].az_resource_group_tags
  enable_diagnostic_setting = true
  logs_destinations_ids     = data.azurerm_log_analytics_workspace.platform_law.id
  firewall_policy_id        = data.azurerm_firewall.platform_firewall.id
  sku = {
    sku1 = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }
  }
  backend_address_pool = {
    bcp1 = {
      name = "backend-pool"
    }
  }
  backend_http_settings = {
    bhs1 = {
      name            = "http-settings"
      port            = 80
      protocol        = "Http"
      request_timeout = 60
    }
  }
  http_listener = {
    hl1 = {
      name                           = "http-listener"
      frontend_ip_configuration_name = "appgw-${module.online_virtual_network["vnet1"].az_virtual_network_name}-ipconfig"
      frontend_port_name             = "port_80"
      protocol                       = "Http"
      firewall_policy_id             = data.azurerm_firewall.platform_firewall.id
    }
  }
  request_routing_rule = {
    rrr1 = {
      name                       = "routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "http-listener"
      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "http-settings"
      priority                   = 100
    }
  }
  frontend_ip_configuration = {
    fip1 = {
      name = "appgw-${module.online_virtual_network["vnet1"].az_virtual_network_name}-ipconfig"
    }
  }
  frontend_port = {
    fp1 = {
      name = "port_80"
      port = 80
    }
    fp2 = {
      name = "port_443"
      port = 443
    }
  }
  gateway_ip_configurations = {
    gip = {
      name      = "gateway-ip-configuration"
      subnet_id = module.online_subnets["snet3"].az_subnet_id
    }
  }
}