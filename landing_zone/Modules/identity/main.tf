resource "random_id" "st" {
  byte_length = 6
  prefix      = "st-ident-"
}

resource "random_id" "kv" {
  byte_length = 6
  prefix      = "kv-ident-"
}

resource "azurerm_resource_group" "dcrg" {
  name     = var.ident_rg_name
  location = var.location
}

resource "azurerm_storage_account" "dcstorage_bootdiag" {
  name                     = var.ident_dcstore_bootdiag_name != "" ? var.ident_dcstore_bootdiag_name : random_id.st.id
  resource_group_name      = azurerm_resource_group.dcrg.name
  location                 = azurerm_resource_group.dcrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.ident_dcstore_bootdiag_tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "dckeyvault" {
  name                       = var.ident_keyvault_name != "" ? var.ident_keyvault_name : random_id.kv.id
  location                   = azurerm_resource_group.dcrg.location
  resource_group_name        = azurerm_resource_group.dcrg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tags                       = var.ident_keyvault_tags
}

resource "azurerm_recovery_services_vault" "dcrecoveryvault" {
  name                = var.ident_recoveryservicesvault_name
  location            = azurerm_resource_group.dcrg.location
  resource_group_name = azurerm_resource_group.dcrg.name
  sku                 = "Standard"

  soft_delete_enabled = var.ident_recoveryservicesvault_softdelete

  tags = var.ident_recoveryservicesvault_tags
}

resource "azurerm_availability_set" "dcavailset_name" {
  count                       = var.ident_dc_count == 2 ? 1 : 0
  name                        = var.ident_dcavailset_name
  location                    = azurerm_resource_group.dcrg.location
  resource_group_name         = azurerm_resource_group.dcrg.name
  platform_fault_domain_count = var.ident_dcavailset_fault_domain_count
}

resource "azurerm_network_interface" "dc01nic" {
  name                = var.ident_dc01_nic_name
  location            = azurerm_resource_group.dcrg.location
  resource_group_name = azurerm_resource_group.dcrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.ident_dc_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ident_dc01_nic_ip
  }
}

resource "azurerm_network_interface" "dc02nic" {
  count               = var.ident_dc_count == 2 ? 1 : 0
  name                = var.ident_dc02_nic_name
  location            = azurerm_resource_group.dcrg.location
  resource_group_name = azurerm_resource_group.dcrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.ident_dc_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ident_dc02_nic_ip
  }
}

resource "azurerm_windows_virtual_machine" "dc01vm" {
  name                = var.ident_dc01_name
  resource_group_name = azurerm_resource_group.dcrg.name
  location            = azurerm_resource_group.dcrg.location
  size                = var.ident_dc01_size
  admin_username      = var.ident_dc_admin_username
  admin_password      = var.ident_dc_admin_password
  depends_on = [
    azurerm_recovery_services_vault.dcrecoveryvault
  ]
  network_interface_ids = [
    azurerm_network_interface.dc01nic.id,
  ]
  availability_set_id = var.ident_dc_count == 2 ? azurerm_availability_set.dcavailset_name[0].id : null
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.dcstorage_bootdiag.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "dc01datadisk" {
  name                 = "${var.ident_dc01_name}-disk1"
  location             = azurerm_resource_group.dcrg.location
  resource_group_name  = azurerm_resource_group.dcrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
}

resource "azurerm_virtual_machine_data_disk_attachment" "dc01datadiskattach" {
  managed_disk_id    = azurerm_managed_disk.dc01datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.dc01vm.id
  lun                = "10"
  caching            = "None"
}

resource "azurerm_windows_virtual_machine" "dc02vm" {
  count               = var.ident_dc_count == 2 ? 1 : 0
  name                = var.ident_dc02_name
  resource_group_name = azurerm_resource_group.dcrg.name
  location            = azurerm_resource_group.dcrg.location
  size                = var.ident_dc02_size
  admin_username      = var.ident_dc_admin_username
  admin_password      = var.ident_dc_admin_password
  depends_on = [
    azurerm_recovery_services_vault.dcrecoveryvault
  ]
  network_interface_ids = [
    azurerm_network_interface.dc02nic[0].id,
  ]
  availability_set_id = azurerm_availability_set.dcavailset_name[0].id
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.dcstorage_bootdiag.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "dc02datadisk" {
  count                = var.ident_dc_count == 2 ? 1 : 0
  name                 = "${var.ident_dc02_name}-disk1"
  location             = azurerm_resource_group.dcrg.location
  resource_group_name  = azurerm_resource_group.dcrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
}

resource "azurerm_virtual_machine_data_disk_attachment" "dc02datadiskattach" {
  count              = var.ident_dc_count == 2 ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.dc02datadisk[0].id
  virtual_machine_id = azurerm_windows_virtual_machine.dc02vm[0].id
  lun                = "10"
  caching            = "None"
}

resource "azurerm_backup_policy_vm" "dc_backup_policy" {
  name                = var.ident_backup_policy_name
  resource_group_name = azurerm_resource_group.dcrg.name
  recovery_vault_name = azurerm_recovery_services_vault.dcrecoveryvault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

resource "azurerm_backup_protected_vm" "dc01backup" {
  resource_group_name = azurerm_resource_group.dcrg.name
  recovery_vault_name = azurerm_recovery_services_vault.dcrecoveryvault.name
  source_vm_id        = azurerm_windows_virtual_machine.dc01vm.id
  backup_policy_id    = azurerm_backup_policy_vm.dc_backup_policy.id
}

resource "azurerm_backup_protected_vm" "dc02backup" {
  count               = var.ident_dc_count == 2 ? 1 : 0
  resource_group_name = azurerm_resource_group.dcrg.name
  recovery_vault_name = azurerm_recovery_services_vault.dcrecoveryvault.name
  source_vm_id        = azurerm_windows_virtual_machine.dc02vm[0].id
  backup_policy_id    = azurerm_backup_policy_vm.dc_backup_policy.id
}