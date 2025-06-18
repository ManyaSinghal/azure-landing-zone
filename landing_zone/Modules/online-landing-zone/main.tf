# Online Landing Zone Module

# Network Resource Group
resource "azurerm_resource_group" "online_network_rg" {
  name     = var.online_network_rg_name
  location = var.location
  tags     = var.resource_group_tags
}

# Application Resource Group
resource "azurerm_resource_group" "online_app_rg" {
  name     = var.online_app_rg_name
  location = var.location
  tags     = var.resource_group_tags
}

# Virtual Network
resource "azurerm_virtual_network" "online_vnet" {
  name                = var.online_vnet_name
  address_space       = var.online_vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.online_network_rg.name
  dns_servers         = var.online_vnet_dns_servers
  tags                = var.vnet_tags
}

# Create Subnets
resource "azurerm_subnet" "online_subnets" {
  for_each             = var.online_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.online_network_rg.name
  virtual_network_name = azurerm_virtual_network.online_vnet.name
  address_prefixes     = each.value
}

# Create NSGs for each subnet (except special subnets)
resource "azurerm_network_security_group" "online_nsgs" {
  for_each            = { for k, v in var.online_subnets : k => v if k != "GatewaySubnet" && k != "AppGatewaySubnet" }
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_network_rg.name
  tags                = var.vnet_tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "online_nsg_associations" {
  for_each                  = { for k, v in var.online_subnets : k => v if k != "GatewaySubnet" && k != "AppGatewaySubnet" }
  subnet_id                 = azurerm_subnet.online_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.online_nsgs[each.key].id
}

# Route Table
resource "azurerm_route_table" "online_route_table" {
  name                = "rt-${var.online_vnet_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_network_rg.name
  tags                = var.vnet_tags

  route {
    name                   = "to-hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

# Associate Route Table with Subnets
resource "azurerm_subnet_route_table_association" "online_rt_associations" {
  for_each       = { for k, v in var.online_subnets : k => v if k != "GatewaySubnet" && k != "AppGatewaySubnet" }
  subnet_id      = azurerm_subnet.online_subnets[each.key].id
  route_table_id = azurerm_route_table.online_route_table.id
}

# App Gateway Public IP
resource "azurerm_public_ip" "app_gateway_ip" {
  name                = "pip-${var.online_vnet_name}-appgw"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_network_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.vnet_tags
}

# Application Gateway
resource "azurerm_application_gateway" "app_gateway" {
  name                = "appgw-${var.online_vnet_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_network_rg.name
  tags                = var.vnet_tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.online_subnets["AppGatewaySubnet"].id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_port {
    name = "port_443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.app_gateway_ip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }
}

# Web App Service Plan
resource "azurerm_service_plan" "online_plan" {
  name                = "plan-online-prod"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_app_rg.name
  os_type             = "Windows"
  sku_name            = "S1"
  tags                = var.resource_group_tags
}

# Web App
resource "azurerm_windows_web_app" "online_webapp" {
  name                = "app-online-web-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_app_rg.name
  service_plan_id     = azurerm_service_plan.online_plan.id
  tags                = var.resource_group_tags

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" = var.online_vnet_dns_servers[0]
  }
}

# Azure SQL Server
resource "azurerm_mssql_server" "online_sql" {
  name                         = "sql-online-${var.environment}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.online_app_rg.name
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  tags                         = var.resource_group_tags
}

# Azure SQL Database
resource "azurerm_mssql_database" "online_db" {
  name           = "sqldb-online-${var.environment}"
  server_id      = azurerm_mssql_server.online_sql.id
  max_size_gb    = 32
  sku_name       = "S1"
  zone_redundant = false
  tags           = var.resource_group_tags
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "pe-${azurerm_mssql_server.online_sql.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.online_app_rg.name
  subnet_id           = azurerm_subnet.online_subnets["snet-online-data"].id
  tags                = var.resource_group_tags

  private_service_connection {
    name                           = "sqlserver-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.online_sql.id
    subresource_names              = ["sqlServer"]
  }
}

# Azure Monitor Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "online_vnet_diag" {
  name                       = "diag-${var.online_vnet_name}"
  target_resource_id         = azurerm_virtual_network.online_vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# App Gateway Diagnostics
resource "azurerm_monitor_diagnostic_setting" "app_gateway_diag" {
  name                       = "diag-appgw"
  target_resource_id         = azurerm_application_gateway.app_gateway.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}