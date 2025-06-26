# online Landing Zone Module - New module implementation
module "online_rgs" {
  source              = "../../Modules/ResourceGroup"
  for_each            = var.resource_groups
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  rg_tags             = each.value["rg_tags"]
}

module "online_vnet_diagnostic" {
  source                  = "../../Modules/AzureMonitor/diagnostic_setting"
  diagnostic_setting_name = ""
  log_analytics_id        = data.azurerm_log_analytics_workspace.platform_law.id
  target_resource_id      = module.online_virtual_network["vnet1"].az_virtual_network_id
  log = {
    l1 = {
      category = "VMProtectionAlerts"
    }
  }
  metric = {
    m1 = {
      category = "AllMetrics"
    }
  }
}

module "online_app_service_plan" {
  source                       = "../../Modules/AzureWebApps/AzureAppService/App_service_plan"
  app_service_plan_name        = "app-online-web-${var.environment}-plan"
  location                     = module.online_rgs["rg1"].az_resource_group_location
  resource_group_name          = module.online_rgs["rg1"].az_resource_group_name
  maximum_elastic_worker_count = null
  os_type                      = "Windows"
  app_service_plan_sku         = "S1"
}
module "online_appservice" {
  source              = "../../Modules/AzureWebApps/AzureAppService/windows_App_service"
  app_service_name    = "app-online-web-${var.environment}"
  location            = module.online_rgs["rg1"].az_resource_group_location
  resource_group_name = module.online_rgs["rg1"].az_resource_group_name
  app_service_tags    = module.online_rgs["rg1"].az_resource_group_tags
  app_service_plan_id = module.online_app_service_plan.az_app_service_plan_id
  site_config = {
    application_stack = {
      apps1 = {
        current_stack  = "dotnet"
        dotnet_version = "v6.0"
      }
    }
  }
  app_settings = {
    "WEBSITE_DNS_SERVER" = module.online_virtual_network["vnet1"].az_vnet_dnsservers[0]
  }
}

module "online_mssql_server" {
  source              = "../../Modules/AzureDatabase/mssql_server"
  server_name         = "sql-online-${var.environment}"
  location            = module.online_rgs["rg1"].az_resource_group_location
  resource_group_name = module.online_rgs["rg1"].az_resource_group_name
  admin_login         = var.admin_username
  admin_password      = var.admin_password
}

module "online_mssql_db" {
  source      = "../../Modules/AzureDatabase/mssql_database"
  db_name     = "sqldb-online-${var.environment}"
  server_id   = module.online_mssql_server.az_mssql_server_id
  sku_name    = "GP_S_Gen5_2"
  min_capacity = 1
  max_size_gb = 32
}

module "online_private_endpoint" {
  source                = "../../Modules/AzureNetwork/PrivateEndpoint"
  private_endpoint_name = "pe-${module.online_mssql_server.az_mssql_server_name}"
  location              = module.online_rgs["rg1"].az_resource_group_location
  resource_group_name   = module.online_rgs["rg1"].az_resource_group_name
  subnet_id             = module.online_subnets["snet2"].az_subnet_id
  private_service_connection = {
    ps1 = {
      name                           = "sqlserver-connection"
      is_manual_connection           = false
      private_connection_resource_id = module.online_mssql_server.az_mssql_server_id
      subresource_names              = ["sqlServer"]
    }
  }
}