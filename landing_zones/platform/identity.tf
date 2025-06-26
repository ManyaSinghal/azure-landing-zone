## Platform domain controller and identity resources

data "azurerm_client_config" "current" {}

module "platform_storage" {
  source                   = "../../Modules/AzureStorage/storage_account"
  storage_account_name     = var.dc_sa_name
  location                 = module.platform_rgs["rg3"].az_resource_group_location
  resource_group_name      = module.platform_rgs["rg3"].az_resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  storage_account_tags     = module.platform_rgs["rg3"].az_resource_group_tags
}

module "plaatfor_kv" {
  source                     = "../../Modules/AzureKeyVault/key_vault"
  key_vault_name             = var.dc_kv_name
  location                   = module.platform_rgs["rg3"].az_resource_group_location
  resource_group_name        = module.platform_rgs["rg3"].az_resource_group_name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  key_vault_tags             = module.platform_rgs["rg3"].az_resource_group_tags
  policies                   = {}
}

module "rsv" {
  source              = "../../Modules/Azure_backup/recovery_service_vault"
  rsv_name            = "rsv-ident-prod-001"
  rsv_soft_delete     = true
  backup_policy_name  = "DC_Backup_Policy"
  location            = module.platform_rgs["rg3"].az_resource_group_location
  resource_group_name = module.platform_rgs["rg3"].az_resource_group_name
  rsv_tags            = module.platform_rgs["rg3"].az_resource_group_tags
  vm_ids              = [for x in module.dc_vms : x.az_virtual_machine_windows_id]
}

resource "azurerm_availability_set" "dcavailset" {
  name                        = "avail-ident-prod-001"
  location                    = module.platform_rgs["rg3"].az_resource_group_location
  resource_group_name         = module.platform_rgs["rg3"].az_resource_group_name
  platform_fault_domain_count = 2
}

module "dc_nic" {
  source                 = "../../Modules/AzureNetwork/network_interface"
  for_each               = var.dc_nics
  network_interface_name = each.value["nic_name"]
  location               = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name    = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  network_interface_tags = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  ip_configuration = {
    ipconfig1 = {
      name                          = "${each.value["nic_name"]}-ipconfig"
      name                          = "internal"
      subnet_id                     = module.platform_subnets["${each.value["snet_key"]}"].az_subnet_id
      private_ip_address_allocation = "Static"
      private_ip_address            = each.value["private_ip_address"]
    }
  }
}

module "dc_vms" {
  source                = "../../Modules/AzureCompute/virtual_machine/windows_vm"
  for_each              = var.dc_vms
  location              = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name   = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  windows_vm_tags       = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  windows_vm_name       = each.value["windows_vm_name"]
  availability_set_id   = azurerm_availability_set.dcavailset.id
  windows_vm_size       = each.value["windows_vm_size"]
  network_interface_ids = [module.dc_nic["${each.value["nic_key"]}"].az_network_interface_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  boot_diagnostics = {
    storage_uri = module.platform_storage.az_storage_account_primary_web_endpoint
  }
  os_disk = {
    caching              = "ReadWrite"
    disk_size_gb         = each.value["disk_size_gb"]
    storage_account_type = "Standard_LRS"
  }
}

module "managed_disk" {
  source               = "../../Modules/AzureCompute/managed_disk"
  for_each             = var.dc_vms
  create_option        = "Empty"
  disk_size_gb         = each.value["disk_size_gb"]
  storage_account_type = "Standard_LRS"
  disk_name            = "${each.value["windows_vm_name"]}-datadisk"
  location             = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_location
  resource_group_name  = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_name
  lun                  = each.value["lun"]
  managed_disk_tags    = module.platform_rgs["${each.value["rg_key"]}"].az_resource_group_tags
  vm_id                = module.dc_vms["${each.key}"].az_virtual_machine_windows_id
} 