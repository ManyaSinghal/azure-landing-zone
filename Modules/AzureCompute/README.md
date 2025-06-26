# Azure Compute Module

This comprehensive module collection provides Terraform modules for creating and managing Azure Compute resources including Virtual Machines, Virtual Machine Scale Sets, Availability Sets, and related compute infrastructure components.

## Overview

Azure Compute provides scalable computing resources in the cloud. This module collection offers a complete set of components to build secure, scalable, and high-performance compute solutions in Azure, supporting both Windows and Linux virtual machines with advanced configurations.

## Module Structure

```
AzureCompute/
└── virtual_machine/              # Virtual Machine creation and management
    └── windows_vm/              # Windows Virtual Machine module
        ├── main.tf              # Main VM resource configuration
        ├── variables.tf         # Variable definitions
        ├── output.tf           # Output values
        └── versions.tf         # Provider requirements
```

## Features

- ✅ Windows and Linux Virtual Machine support
- ✅ Multiple VM sizes and generations
- ✅ Availability Sets and Availability Zones
- ✅ Managed and unmanaged disk support
- ✅ Custom and marketplace image support
- ✅ Network interface configuration
- ✅ Boot diagnostics and monitoring
- ✅ Identity management (System/User assigned)
- ✅ Extensions and custom scripts
- ✅ Backup and disaster recovery integration
- ✅ Auto-shutdown and cost management

## Quick Start

### Basic Windows Virtual Machine

```hcl
# Network Interface for VM
module "vm_network_interface" {
  source = "./Modules/AzureNetwork/network_interface"
  
  nic_name            = "nic-vm-web-001"
  resource_group_name = "rg-compute-prod"
  location           = "East US 2"
  subnet_id          = module.subnet_web.subnet_id
  
  ip_configurations = [
    {
      name                          = "internal"
      subnet_id                     = module.subnet_web.subnet_id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id         = null
    }
  ]
}

# Basic Windows VM
module "windows_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name       = "vm-web-prod-001"
  resource_group_name   = "rg-compute-prod"
  location             = "East US 2"
  windows_vm_size      = "Standard_D2s_v3"
  network_interface_ids = [module.vm_network_interface.network_interface_id]
  
  # OS Configuration
  os_profile = {
    admin_username = "vmadmin"
    admin_password = var.admin_password  # Use Key Vault reference
  }
  
  # Storage configuration
  storage_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  
  storage_os_disk = {
    name              = "disk-os-vm-web-001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  
  # Enable boot diagnostics
  boot_diagnostics = {
    enabled     = true
    storage_uri = module.diagnostics_storage.primary_blob_endpoint
  }
  
  tags = {
    Environment = "Production"
    Role        = "WebServer"
    Owner       = "Platform Team"
    Backup      = "Required"
  }
}
```

### Production Windows VM with High Availability

```hcl
# Availability Set for VMs
resource "azurerm_availability_set" "web_avset" {
  name                = "avset-web-prod"
  location           = "East US 2"
  resource_group_name = "rg-compute-prod"
  
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  
  tags = {
    Environment = "Production"
    Purpose     = "HighAvailability"
  }
}

# Production Windows VM with enhanced configuration
module "production_windows_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name       = "vm-web-prod-001"
  resource_group_name   = "rg-compute-prod"
  location             = "East US 2"
  windows_vm_size      = "Standard_D4s_v4"
  availability_set_id  = azurerm_availability_set.web_avset.id
  network_interface_ids = [module.vm_network_interface.network_interface_id]
  
  # High availability configuration
  zones = ["1"]  # Availability Zone deployment
  
  # OS Configuration with Key Vault integration
  os_profile = {
    admin_username = "vmadmin"
    admin_password = "@Microsoft.KeyVault(SecretUri=${module.key_vault_secret.secret_id})"
  }
  
  # Premium OS disk for better performance
  storage_os_disk = {
    name              = "disk-os-vm-web-prod-001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }
  
  # Latest Windows Server image
  storage_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  
  # Data disks for application data
  storage_data_disks = [
    {
      name              = "disk-data-vm-web-prod-001"
      managed_disk_type = "Premium_LRS"
      create_option     = "Empty"
      disk_size_gb      = 256
      lun               = 0
      caching           = "ReadOnly"
    }
  ]
  
  # Enable managed identity
  identity_type = "SystemAssigned"
  
  # Boot diagnostics with dedicated storage
  boot_diagnostics = {
    enabled     = true
    storage_uri = module.diagnostics_storage.primary_blob_endpoint
  }
  
  # Enable backup
  enable_automatic_updates = true
  patch_mode              = "AutomaticByPlatform"
  
  tags = {
    Environment     = "Production"
    Role           = "WebServer"
    Tier           = "Frontend"
    HighAvailability = "Required"
    Backup         = "Daily"
    Monitoring     = "Enhanced"
    Compliance     = "SOX"
  }
}
```

### Linux Virtual Machine

```hcl
# Linux VM configuration (requires separate Linux VM module)
module "linux_vm" {
  source = "./Modules/AzureCompute/virtual_machine/linux_vm"
  
  linux_vm_name        = "vm-app-prod-001"
  resource_group_name  = "rg-compute-prod"
  location            = "East US 2"
  linux_vm_size       = "Standard_D2s_v3"
  network_interface_ids = [module.app_network_interface.network_interface_id]
  
  # OS Configuration with SSH key
  os_profile = {
    admin_username                = "azureuser"
    disable_password_authentication = true
  }
  
  os_profile_linux_config = {
    ssh_keys = [
      {
        path     = "/home/azureuser/.ssh/authorized_keys"
        key_data = file("~/.ssh/id_rsa.pub")
      }
    ]
  }
  
  # Ubuntu LTS image
  storage_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  
  storage_os_disk = {
    name              = "disk-os-vm-app-001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  
  tags = {
    Environment = "Production"
    OS          = "Linux"
    Role        = "Application"
  }
}
```

### Virtual Machine Scale Set

```hcl
# VM Scale Set for auto-scaling workloads
module "vmss_web" {
  source = "./Modules/AzureCompute/virtual_machine_scale_set"
  
  vmss_name           = "vmss-web-prod"
  resource_group_name = "rg-compute-prod"
  location           = "East US 2"
  sku_name           = "Standard_D2s_v3"
  instances          = 3
  
  # Auto-scaling configuration
  upgrade_policy_mode = "Automatic"
  
  # OS Configuration
  os_profile = {
    admin_username = "vmadmin"
    admin_password = var.admin_password
  }
  
  # Network configuration
  network_profile = {
    name    = "webscaleset-nic"
    primary = true
    
    ip_configurations = [
      {
        name                                   = "internal"
        subnet_id                             = module.subnet_web.subnet_id
        load_balancer_backend_address_pool_ids = [module.load_balancer.backend_address_pool_id]
        load_balancer_inbound_nat_rules_ids   = []
        primary                               = true
      }
    ]
  }
  
  # Custom script extension
  extensions = [
    {
      name                 = "CustomScriptExtension"
      publisher            = "Microsoft.Compute"
      type                 = "CustomScriptExtension"
      type_handler_version = "1.10"
      auto_upgrade_minor_version = true
      
      settings = jsonencode({
        fileUris = ["https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/application-workloads/wordpress/wordpress-single-vm-ubuntu/install_wordpress.sh"]
        commandToExecute = "sh install_wordpress.sh"
      })
    }
  ]
  
  tags = {
    Environment = "Production"
    AutoScaling = "Enabled"
    LoadBalanced = "True"
  }
}
```

## VM Sizes and Performance

### General Purpose VMs

| Series | Use Case | vCPUs | RAM | Temp Storage | Network Performance |
|--------|----------|-------|-----|--------------|-------------------|
| **Dv4/Dsv4** | Balanced CPU-to-memory | 2-64 | 8-256 GB | Local SSD | Moderate to High |
| **Dv5/Dsv5** | Latest generation balanced | 2-96 | 8-384 GB | Local SSD | Moderate to High |
| **Av2** | Entry-level economical | 1-8 | 0.75-14 GB | Local SSD | Low to Moderate |

### Compute Optimized VMs

| Series | Use Case | vCPUs | RAM | Temp Storage | Network Performance |
|--------|----------|-------|-----|--------------|-------------------|
| **Fv2** | High CPU performance | 2-72 | 4-144 GB | Local SSD | Moderate to High |
| **FX** | High frequency CPU | 4-48 | 8-96 GB | Local SSD | High |

### Memory Optimized VMs

| Series | Use Case | vCPUs | RAM | Temp Storage | Network Performance |
|--------|----------|-------|-----|--------------|-------------------|
| **Ev4/Esv4** | Memory intensive | 2-64 | 16-504 GB | Local SSD | Moderate to High |
| **Ev5/Esv5** | Latest memory optimized | 2-96 | 16-672 GB | Local SSD | Moderate to High |
| **Mv2** | Largest memory | 208-416 | 2.9-11.4 TB | Local SSD | Extremely High |

### Storage Optimized VMs

| Series | Use Case | vCPUs | RAM | Temp Storage | Network Performance |
|--------|----------|-------|-----|--------------|-------------------|
| **Lsv2** | High disk throughput | 8-80 | 64-640 GB | NVMe SSD | High |
| **Lsv3** | Latest storage optimized | 8-64 | 64-512 GB | NVMe SSD | High |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_machine.az_virtual_machine_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|----------|---------|
| windows_vm_name | Name of the Azure VM | `string` | `""` | ✅ | `"vm-web-prod-001"` |
| resource_group_name | Name of the Resource Group | `string` | - | ✅ | `"rg-compute-prod"` |
| location | Azure region for the VM | `string` | `""` | ✅ | `"East US 2"` |
| windows_vm_size | VM size specification | `string` | `"Standard_D2s_v3"` | ❌ | `"Standard_D4s_v4"` |
| network_interface_ids | List of Network Interface IDs | `list(string)` | `[]` | ✅ | `["/subscriptions/.../networkInterfaces/nic-vm-001"]` |
| availability_set_id | Availability Set ID | `string` | `null` | ❌ | `"/subscriptions/.../availabilitySets/avset-web"` |
| zones | Availability Zones | `list(string)` | `null` | ❌ | `["1"]` |
| os_profile | OS profile configuration | `object` | - | ✅ | See OS profile section |
| storage_image_reference | VM image reference | `object` | - | ✅ | See image reference section |
| storage_os_disk | OS disk configuration | `object` | - | ✅ | See disk configuration section |
| storage_data_disks | Data disk configurations | `list(object)` | `[]` | ❌ | See data disk section |
| identity_type | Managed identity type | `string` | `"SystemAssigned"` | ❌ | `"UserAssigned"` |
| boot_diagnostics | Boot diagnostics configuration | `object` | `{}` | ❌ | See boot diagnostics section |

### OS Profile Configuration

```hcl
os_profile = {
  admin_username = "vmadmin"
  admin_password = var.admin_password
  custom_data    = base64encode(file("scripts/init.ps1"))
}
```

### Storage Image Reference

```hcl
# Windows Server 2022
storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-azure-edition"
  version   = "latest"
}

# Ubuntu 20.04 LTS
storage_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts-gen2"
  version   = "latest"
}

# Custom image
storage_image_reference = {
  id = "/subscriptions/.../resourceGroups/rg-images/providers/Microsoft.Compute/images/custom-web-image"
}
```

### Storage OS Disk Configuration

```hcl
storage_os_disk = {
  name              = "disk-os-vm-web-001"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Premium_LRS"
  disk_size_gb      = 128
}
```

### Data Disk Configuration

```hcl
storage_data_disks = [
  {
    name              = "disk-data-vm-web-001"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    disk_size_gb      = 256
    lun               = 0
    caching           = "ReadOnly"
  },
  {
    name              = "disk-logs-vm-web-001"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    disk_size_gb      = 128
    lun               = 1
    caching           = "None"
  }
]
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| virtual_machine_id | The ID of the Virtual Machine | `string` |
| virtual_machine_name | The name of the Virtual Machine | `string` |
| virtual_machine_private_ip | Private IP address of the VM | `string` |
| virtual_machine_public_ip | Public IP address of the VM | `string` |
| identity_principal_id | Principal ID of the managed identity | `string` |

## High Availability Configurations

### Availability Sets

```hcl
# Availability Set for VMs
resource "azurerm_availability_set" "app_avset" {
  name                = "avset-app-prod"
  location           = "East US 2"
  resource_group_name = "rg-compute-prod"
  
  platform_fault_domain_count  = 3  # Max 3 in most regions
  platform_update_domain_count = 5  # Max 20
  managed                      = true
  
  proximity_placement_group_id = azurerm_proximity_placement_group.app_ppg.id
  
  tags = {
    Environment = "Production"
    Purpose     = "HighAvailability"
  }
}

# Multiple VMs in Availability Set
module "web_vm_01" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name     = "vm-web-prod-001"
  availability_set_id = azurerm_availability_set.app_avset.id
  # ... other configuration
}

module "web_vm_02" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name     = "vm-web-prod-002"
  availability_set_id = azurerm_availability_set.app_avset.id
  # ... other configuration
}
```

### Availability Zones

```hcl
# VMs across Availability Zones
module "web_vm_zone1" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-web-prod-z1-001"
  zones          = ["1"]
  # ... other configuration
}

module "web_vm_zone2" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-web-prod-z2-001"
  zones          = ["2"]
  # ... other configuration
}

module "web_vm_zone3" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-web-prod-z3-001"
  zones          = ["3"]
  # ... other configuration
}
```

### Proximity Placement Groups

```hcl
# Proximity Placement Group for low latency
resource "azurerm_proximity_placement_group" "app_ppg" {
  name                = "ppg-app-prod"
  location           = "East US 2"
  resource_group_name = "rg-compute-prod"
  
  tags = {
    Purpose = "LowLatency"
    Tier    = "Application"
  }
}

module "low_latency_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name              = "vm-app-prod-001"
  proximity_placement_group_id = azurerm_proximity_placement_group.app_ppg.id
  # ... other configuration
}
```

## Security Configurations

### Managed Identity

```hcl
module "secure_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-secure-prod-001"
  # ... other configuration
  
  # Enable system-assigned managed identity
  identity_type = "SystemAssigned"
}

# Role assignment for VM managed identity
resource "azurerm_role_assignment" "vm_key_vault_access" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.secure_vm.identity_principal_id
}

# User-assigned managed identity
resource "azurerm_user_assigned_identity" "vm_identity" {
  location            = "East US 2"
  name                = "id-vm-app-prod"
  resource_group_name = "rg-identity-prod"
}

module "vm_with_user_identity" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-app-prod-001"
  identity_type   = "UserAssigned"
  identity_ids    = [azurerm_user_assigned_identity.vm_identity.id]
  # ... other configuration
}
```

### Disk Encryption

```hcl
# Key Vault for disk encryption
module "disk_encryption_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name              = "kv-diskenc-prod"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  # ... other configuration
}

# Disk encryption set
resource "azurerm_disk_encryption_set" "vm_encryption" {
  name                = "des-vm-encryption"
  resource_group_name = "rg-security-prod"
  location           = "East US 2"
  key_vault_key_id   = module.encryption_key.key_id
  
  identity {
    type = "SystemAssigned"
  }
}

# VM with encrypted disks
module "encrypted_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-encrypted-prod-001"
  
  # Encrypted OS disk
  storage_os_disk = {
    name                   = "disk-os-encrypted-001"
    caching               = "ReadWrite"
    create_option         = "FromImage"
    managed_disk_type     = "Premium_LRS"
    disk_encryption_set_id = azurerm_disk_encryption_set.vm_encryption.id
  }
  
  # ... other configuration
}
```

### Network Security

```hcl
# Network Security Group for VM subnet
module "vm_nsg" {
  source = "./Modules/AzureNetwork/network_security_group"
  
  nsg_name            = "nsg-vm-web-prod"
  resource_group_name = "rg-network-prod"
  location           = "East US 2"
  
  security_rules = [
    {
      name                       = "AllowHTTPS"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowRDP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "10.0.0.0/8"  # Only from internal network
      destination_address_prefix = "*"
    }
  ]
}

# Application Security Group
resource "azurerm_application_security_group" "web_asg" {
  name                = "asg-web-prod"
  location           = "East US 2"
  resource_group_name = "rg-security-prod"
}

# Associate VM NIC with ASG
resource "azurerm_network_interface_application_security_group_association" "vm_asg" {
  network_interface_id          = module.vm_network_interface.network_interface_id
  application_security_group_id = azurerm_application_security_group.web_asg.id
}
```

## VM Extensions and Custom Scripts

### Windows VM Extensions

```hcl
# IIS Installation Extension
resource "azurerm_virtual_machine_extension" "iis_install" {
  name                 = "install-iis"
  virtual_machine_id   = module.windows_vm.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  
  settings = jsonencode({
    commandToExecute = "powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item 'C:\\inetpub\\wwwroot\\iisstart.htm' && powershell.exe Add-Content -Path 'C:\\inetpub\\wwwroot\\iisstart.htm' -Value $('Hello World from ' + $env:computername)"
  })
  
  tags = {
    Purpose = "WebServerSetup"
  }
}

# Domain Join Extension
resource "azurerm_virtual_machine_extension" "domain_join" {
  name                 = "join-domain"
  virtual_machine_id   = module.windows_vm.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  
  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = var.domain_ou_path
    User    = var.domain_join_user
    Restart = "true"
    Options = "3"
  })
  
  protected_settings = jsonencode({
    Password = var.domain_join_password
  })
}

# Antimalware Extension
resource "azurerm_virtual_machine_extension" "antimalware" {
  name                 = "antimalware"
  virtual_machine_id   = module.windows_vm.virtual_machine_id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.3"
  
  settings = jsonencode({
    AntimalwareEnabled = true
    RealtimeProtectionEnabled = "true"
    ScheduledScanSettings = {
      isEnabled = "true"
      day       = "7"
      time      = "120"
      scanType  = "Quick"
    }
    Exclusions = {
      Extensions = "*.log;*.ldf"
      Paths      = "D:\\IISlogs;D:\\DatabaseLogs"
      Processes  = "mssence.svc"
    }
  })
}
```

### Linux VM Extensions

```hcl
# Custom Script Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_script" {
  name                 = "install-docker"
  virtual_machine_id   = module.linux_vm.virtual_machine_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  
  settings = jsonencode({
    fileUris = ["https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/docker-simple-on-ubuntu/scripts/docker-setup-ubuntu.sh"]
    commandToExecute = "sh docker-setup-ubuntu.sh"
  })
}

# Azure Monitor Agent
resource "azurerm_virtual_machine_extension" "monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = module.linux_vm.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}
```

## Backup and Disaster Recovery

### Azure Backup Integration

```hcl
# Recovery Services Vault
resource "azurerm_recovery_services_vault" "vm_backup" {
  name                = "rsv-vm-backup-prod"
  location           = "East US 2"
  resource_group_name = "rg-backup-prod"
  sku                = "Standard"
  
  soft_delete_enabled = true
  
  tags = {
    Purpose = "VMBackup"
  }
}

# Backup Policy
resource "azurerm_backup_policy_vm" "daily_backup" {
  name                = "policy-vm-daily"
  resource_group_name = "rg-backup-prod"
  recovery_vault_name = azurerm_recovery_services_vault.vm_backup.name
  
  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  
  retention_daily {
    count = 30
  }
  
  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }
  
  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
  
  retention_yearly {
    count    = 5
    weekdays = ["Sunday"]
    weeks    = ["First"]
    months   = ["January"]
  }
}

# Protected VM
resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = "rg-backup-prod"
  recovery_vault_name = azurerm_recovery_services_vault.vm_backup.name
  source_vm_id        = module.windows_vm.virtual_machine_id
  backup_policy_id    = azurerm_backup_policy_vm.daily_backup.id
}
```

### Site Recovery for DR

```hcl
# Site Recovery Vault (separate from backup vault)
resource "azurerm_recovery_services_vault" "site_recovery" {
  name                = "rsv-site-recovery-prod"
  location           = "West US 2"  # DR region
  resource_group_name = "rg-dr-westus2"
  sku                = "Standard"
  
  tags = {
    Purpose = "DisasterRecovery"
  }
}

# Site Recovery Fabric
resource "azurerm_site_recovery_fabric" "primary" {
  name                = "fabric-primary-eastus2"
  resource_group_name = "rg-dr-westus2"
  recovery_vault_name = azurerm_recovery_services_vault.site_recovery.name
  location           = "East US 2"
}

resource "azurerm_site_recovery_fabric" "secondary" {
  name                = "fabric-secondary-westus2"
  resource_group_name = "rg-dr-westus2"
  recovery_vault_name = azurerm_recovery_services_vault.site_recovery.name
  location           = "West US 2"
}
```

## Monitoring and Diagnostics

### Azure Monitor Integration

```hcl
# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "vm_monitoring" {
  name                = "law-vm-monitoring-prod"
  location           = "East US 2"
  resource_group_name = "rg-monitoring-prod"
  sku                = "PerGB2018"
  retention_in_days  = 30
}

# VM Insights for enhanced monitoring
resource "azurerm_virtual_machine_extension" "dependency_agent" {
  name                 = "DependencyAgentWindows"
  virtual_machine_id   = module.windows_vm.virtual_machine_id
  publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                 = "DependencyAgentWindows"
  type_handler_version = "9.5"
  
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "monitor_agent" {
  name                 = "AzureMonitorWindowsAgent"
  virtual_machine_id   = module.windows_vm.virtual_machine_id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorWindowsAgent"
  type_handler_version = "1.0"
  
  auto_upgrade_minor_version = true
}

# Data Collection Rule
resource "azurerm_monitor_data_collection_rule" "vm_dcr" {
  name                = "dcr-vm-performance"
  resource_group_name = "rg-monitoring-prod"
  location           = "East US 2"
  
  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.vm_monitoring.id
      name                  = "destination-log"
    }
  }
  
  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-Event"]
    destinations = ["destination-log"]
  }
  
  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available Bytes",
        "\\LogicalDisk(_Total)\\Disk Reads/sec",
        "\\LogicalDisk(_Total)\\Disk Writes/sec"
      ]
      name = "perfCounterDataSource60"
    }
    
    windows_event_log {
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
      name = "eventLogsDataSource"
    }
  }
}

# Associate DCR with VM
resource "azurerm_monitor_data_collection_rule_association" "vm_dcr_association" {
  name                    = "dcra-vm-perf"
  target_resource_id      = module.windows_vm.virtual_machine_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vm_dcr.id
}
```

### Performance Alerts

```hcl
# CPU utilization alert
resource "azurerm_monitor_metric_alert" "vm_cpu_alert" {
  name                = "vm-high-cpu-usage"
  resource_group_name = "rg-monitoring-prod"
  scopes              = [module.windows_vm.virtual_machine_id]
  description         = "Alert when VM CPU usage is consistently high"
  
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
    
    dimension {
      name     = "VMName"
      operator = "Include"
      values   = [module.windows_vm.virtual_machine_name]
    }
  }
  
  window_size        = "PT5M"
  frequency          = "PT1M"
  severity           = 2
  auto_mitigate      = true
  
  action {
    action_group_id = var.action_group_id
  }
}

# Memory utilization alert
resource "azurerm_monitor_metric_alert" "vm_memory_alert" {
  name                = "vm-low-memory"
  resource_group_name = "rg-monitoring-prod"
  scopes              = [module.windows_vm.virtual_machine_id]
  description         = "Alert when VM available memory is low"
  
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1073741824  # 1 GB in bytes
  }
  
  window_size   = "PT5M"
  frequency     = "PT1M"
  severity      = 1
  auto_mitigate = true
  
  action {
    action_group_id = var.action_group_id
  }
}
```

## Cost Optimization

### Auto-Shutdown Configuration

```hcl
# Auto-shutdown for development VMs
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown" {
  virtual_machine_id = module.dev_vm.virtual_machine_id
  location          = "East US 2"
  enabled           = true
  
  daily_recurrence_time = "1900"
  timezone             = "Eastern Standard Time"
  
  notification_settings {
    enabled         = true
    time_in_minutes = 60
    email           = "admin@company.com"
  }
  
  tags = {
    Purpose = "CostOptimization"
  }
}
```

### Spot VMs for Cost Savings

```hcl
# Spot VM for non-critical workloads
module "spot_vm" {
  source = "./Modules/AzureCompute/virtual_machine/windows_vm"
  
  windows_vm_name = "vm-spot-dev-001"
  # ... other configuration
  
  # Spot VM configuration
  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = 0.1  # Maximum price willing to pay
  
  tags = {
    Environment = "Development"
    Priority    = "Spot"
    CostSaving  = "Enabled"
  }
}
```

### Reserved Instances Cost Analysis

```hcl
# Variables for cost analysis
locals {
  vm_sizes_cost_analysis = {
    "Standard_D2s_v3" = {
      vcpus              = 2
      memory_gb          = 8
      payg_monthly_cost  = 70.08   # Pay-as-you-go
      ri_1year_monthly   = 45.26   # 1-year reserved instance
      ri_3year_monthly   = 32.34   # 3-year reserved instance
      spot_monthly       = 7.01    # Approximate spot pricing
    }
    "Standard_D4s_v3" = {
      vcpus              = 4
      memory_gb          = 16
      payg_monthly_cost  = 140.16
      ri_1year_monthly   = 90.53
      ri_3year_monthly   = 64.67
      spot_monthly       = 14.02
    }
  }
}
```

## Troubleshooting

### Common Issues

#### 1. VM Boot Issues

```bash
# Check boot diagnostics
az vm boot-diagnostics get-boot-log \
  --resource-group "rg-compute-prod" \
  --name "vm-web-prod-001"

# Enable boot diagnostics if not enabled
az vm boot-diagnostics enable \
  --resource-group "rg-compute-prod" \
  --name "vm-web-prod-001" \
  --storage "https://diagstorage.blob.core.windows.net/"
```

#### 2. Network Connectivity Issues

```bash
# Check effective NSG rules
az network nic list-effective-nsg \
  --resource-group "rg-compute-prod" \
  --name "nic-vm-web-001"

# Test network connectivity
az network watcher test-connectivity \
  --source-resource "vm-web-prod-001" \
  --dest-resource "vm-app-prod-001" \
  --resource-group "rg-compute-prod" \
  --dest-port 80
```

#### 3. Performance Issues

```bash
# Check VM metrics
az monitor metrics list \
  --resource "/subscriptions/.../resourceGroups/rg-compute-prod/providers/Microsoft.Compute/virtualMachines/vm-web-prod-001" \
  --metric "Percentage CPU" \
  --start-time 2025-06-24T00:00:00Z \
  --end-time 2025-06-25T00:00:00Z

# Check disk performance
az monitor metrics list \
  --resource "/subscriptions/.../resourceGroups/rg-compute-prod/providers/Microsoft.Compute/virtualMachines/vm-web-prod-001" \
  --metric "Disk Read Operations/Sec,Disk Write Operations/Sec" \
  --start-time 2025-06-24T00:00:00Z \
  --end-time 2025-06-25T00:00:00Z
```

### Validation Commands

```bash
# Check VM status
az vm show \
  --resource-group "rg-compute-prod" \
  --name "vm-web-prod-001" \
  --show-details

# List VM extensions
az vm extension list \
  --resource-group "rg-compute-prod" \
  --vm-name "vm-web-prod-001"

# Check VM sizes available in region
az vm list-sizes --location "East US 2"

# Check VM usage and quotas
az vm list-usage --location "East US 2"

# Get VM instance metadata
az vm run-command invoke \
  --resource-group "rg-compute-prod" \
  --name "vm-web-prod-001" \
  --command-id "RunPowerShellScript" \
  --scripts "Invoke-RestMethod -Headers @{\"Metadata\"=\"true\"} -URI http://169.254.169.254/metadata/instance?api-version=2021-02-01"
```

## Best Practices Summary

### 1. Security
- ✅ Use managed identities instead of stored credentials
- ✅ Enable disk encryption for sensitive workloads
- ✅ Implement proper network segmentation with NSGs
- ✅ Regular security patching and updates
- ✅ Use Azure Security Center recommendations

### 2. High Availability
- ✅ Deploy VMs across Availability Zones or Availability Sets
- ✅ Use load balancers for distributing traffic
- ✅ Implement proper backup and disaster recovery
- ✅ Monitor VM health and performance

### 3. Performance
- ✅ Choose appropriate VM sizes for workload requirements
- ✅ Use Premium SSD for production workloads
- ✅ Optimize network performance with accelerated networking
- ✅ Monitor and tune based on performance metrics

### 4. Cost Management
- ✅ Use Reserved Instances for predictable workloads
- ✅ Implement auto-shutdown for development VMs
- ✅ Consider Spot VMs for non-critical workloads
- ✅ Regular cost reviews and rightsizing

### 5. Operational Excellence
- ✅ Implement comprehensive monitoring and alerting
- ✅ Use automation for deployment and management
- ✅ Document operational procedures
- ✅ Regular backup testing and disaster recovery drills

## Example Implementation

See the [Example](./Example/) directory for complete implementation examples including:
- Basic Windows VM deployment
- High availability multi-VM setup
- Security-hardened VM configuration
- Cost-optimized development environment
- Production-ready monitoring setup

---

**Module Collection Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0
