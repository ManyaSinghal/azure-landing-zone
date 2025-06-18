# Corp Landing Zone Module

# Network Resource Group
resource "azurerm_resource_group" "corp_network_rg" {
  name     = var.corp_network_rg_name
  location = var.location
  tags     = var.resource_group_tags
}

# Application Resource Group
resource "azurerm_resource_group" "corp_app_rg" {
  name     = var.corp_app_rg_name
  location = var.location
  tags     = var.resource_group_tags
}

# Virtual Network
resource "azurerm_virtual_network" "corp_vnet" {
  name                = var.corp_vnet_name
  address_space       = var.corp_vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_network_rg.name
  dns_servers         = var.corp_vnet_dns_servers
  tags                = var.vnet_tags
}

# Create Subnets
resource "azurerm_subnet" "corp_subnets" {
  for_each             = var.corp_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.corp_network_rg.name
  virtual_network_name = azurerm_virtual_network.corp_vnet.name
  address_prefixes     = each.value
}

# Create NSGs for each subnet (except special subnets)
resource "azurerm_network_security_group" "corp_nsgs" {
  for_each            = { for k, v in var.corp_subnets : k => v if k != "GatewaySubnet" }
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_network_rg.name
  tags                = var.vnet_tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "corp_nsg_associations" {
  for_each                  = { for k, v in var.corp_subnets : k => v if k != "GatewaySubnet" }
  subnet_id                 = azurerm_subnet.corp_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.corp_nsgs[each.key].id
}

# Route Table
resource "azurerm_route_table" "corp_route_table" {
  name                = "rt-${var.corp_vnet_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_network_rg.name
  tags                = var.vnet_tags

  route {
    name                   = "to-hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

# Associate Route Table with Subnets
resource "azurerm_subnet_route_table_association" "corp_rt_associations" {
  for_each       = { for k, v in var.corp_subnets : k => v if k != "GatewaySubnet" }
  subnet_id      = azurerm_subnet.corp_subnets[each.key].id
  route_table_id = azurerm_route_table.corp_route_table.id
}

# Create VMs in the app resource group
resource "azurerm_network_interface" "corp_vm_nic" {
  count               = var.vm_count
  name                = "nic-corp-vm-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_app_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.corp_subnets["snet-corp-vm"].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.resource_group_tags
}

resource "azurerm_windows_virtual_machine" "corp_vm" {
  count               = var.vm_count
  name                = "vm-corp-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_app_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.corp_vm_nic[count.index].id,
  ]

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

  tags = var.resource_group_tags
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "corp_vault" {
  name                = "rsv-corp-prod-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.corp_app_rg.name
  sku                 = "Standard"
  soft_delete_enabled = true
  tags                = var.resource_group_tags
}

# Backup Policy
resource "azurerm_backup_policy_vm" "corp_backup_policy" {
  name                = "VM-Backup-Policy"
  resource_group_name = azurerm_resource_group.corp_app_rg.name
  recovery_vault_name = azurerm_recovery_services_vault.corp_vault.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count    = 1
    weekdays = ["Sunday"]
    weeks    = ["First"]
    months   = ["January"]
  }
}

# VM Backup Protection
resource "azurerm_backup_protected_vm" "corp_vm_backup" {
  count               = var.vm_count
  resource_group_name = azurerm_resource_group.corp_app_rg.name
  recovery_vault_name = azurerm_recovery_services_vault.corp_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.corp_vm[count.index].id
  backup_policy_id    = azurerm_backup_policy_vm.corp_backup_policy.id
}

# Azure Monitor Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "corp_vnet_diag" {
  name                       = "diag-${var.corp_vnet_name}"
  target_resource_id         = azurerm_virtual_network.corp_vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}