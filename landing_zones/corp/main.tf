# Corp Landing Zone Module - New module implementation
module "corp_rgs" {
  source              = "../../Modules/ResourceGroup"
  for_each            = var.resource_groups
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  rg_tags             = each.value["rg_tags"]
}

module "rsv" {
  source              = "../../Modules/Azure_backup/recovery_service_vault"
  rsv_name            = "rsv-corp-prod-001"
  rsv_soft_delete     = true
  backup_policy_name  = "VM-Backup-Policy"
  location            = module.corp_rgs["rg2"].az_resource_group_location
  resource_group_name = module.corp_rgs["rg2"].az_resource_group_name
  rsv_tags            = module.corp_rgs["rg2"].az_resource_group_tags
  vm_ids              = [for x in module.corp_vms : x.az_virtual_machine_windows_id]
}

module "corp_nic" {
  source                 = "../../Modules/AzureNetwork/network_interface"
  for_each               = var.corp_nics
  network_interface_name = each.value["nic_name"]
  location               = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name    = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_name
  network_interface_tags = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  ip_configuration = {
    ipconfig1 = {
      name                          = "${each.value["nic_name"]}-ipconfig"
      name                          = "internal"
      subnet_id                     = module.corp_subnets["${each.value["snet_key"]}"].az_subnet_id
      private_ip_address_allocation = "Dynamic"
    }
  }
}

module "corp_vms" {
  source                = "../../Modules/AzureCompute/virtual_machine/windows_vm"
  for_each              = var.corp_vms
  location              = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name   = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_name
  windows_vm_tags       = module.corp_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  windows_vm_name       = each.value["windows_vm_name"]
  windows_vm_size       = each.value["windows_vm_size"]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.corp_nic["${each.value["nic_key"]}"].az_network_interface_id]
  os_disk = {
    caching              = "ReadWrite"
    disk_size_gb         = each.value["disk_size_gb"]
    storage_account_type = "Standard_LRS"
  }
}

module "corp_diagnostic" {
  source                  = "../../Modules/AzureMonitor/diagnostic_setting"
  diagnostic_setting_name = "diag-${module.corp_virtual_network["vnet1"].az_virtual_network_name}"
  log_analytics_id        = data.azurerm_log_analytics_workspace.platform_law.id
  target_resource_id      = module.corp_virtual_network["vnet1"].az_virtual_network_id
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