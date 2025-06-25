# Azure Key Vault Module

This comprehensive module collection provides Terraform modules for creating and managing Azure Key Vault resources including Key Vaults, access policies, secrets, keys, certificates, and certificate issuers.

## Overview

Azure Key Vault is a cloud service that provides secure storage and management of sensitive information such as keys, secrets, and certificates. This module collection offers a complete set of components to build secure, compliant, and well-managed Key Vault infrastructure in Azure.

## Module Structure

```
AzureKeyVault/
├── key_vault/                    # Core Key Vault creation and management
├── key_vault_access_policy/      # Access policy management
├── key_vault_secret/            # Secret management
├── key_vault_key/               # Key management (encryption keys)
├── key_vault_certificate/       # Certificate management
└── key_vault_certificate_issuer/ # Certificate issuer configuration
```

## Features

- ✅ Azure Key Vault creation with multiple SKU options
- ✅ RBAC and access policy-based authorization
- ✅ Network access controls and private endpoints
- ✅ Secrets, keys, and certificates management
- ✅ Soft delete and purge protection
- ✅ Integration with Azure services (VMs, ARM templates, Disk Encryption)
- ✅ Certificate issuers and automated certificate management
- ✅ Comprehensive audit logging and monitoring
- ✅ HSM-backed keys (Premium SKU)

## Quick Start

### Basic Key Vault Setup

```hcl
# Data source for current user
data "azurerm_client_config" "current" {}

module "key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name      = "kv-myapp-prod-eastus2"
  resource_group_name = "rg-security-prod"
  location           = "East US 2"
  tenant_id          = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"
  
  # Enable for Azure services
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  
  # Security settings
  enable_rbac_authorization    = true
  purge_protection_enabled     = true
  soft_delete_retention_days   = 90
  
  # Network access control
  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["203.0.113.0/24"]  # Office IP ranges
    virtual_network_subnet_ids = [
      "/subscriptions/.../subnets/subnet-app"
    ]
  }
  
  key_vault_tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Security    = "High"
    Compliance  = "Required"
  }
}
```

### Production Key Vault with Access Policies

```hcl
data "azurerm_client_config" "current" {}

# Application service principal
data "azuread_service_principal" "app_sp" {
  display_name = "myapp-production-sp"
}

module "production_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name      = "kv-myapp-prod-eastus2"
  resource_group_name = "rg-security-prod"
  location           = "East US 2"
  tenant_id          = data.azurerm_client_config.current.tenant_id
  sku_name           = "premium"  # HSM-backed keys
  
  # Azure service integrations
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  
  # Security features
  enable_rbac_authorization    = false  # Using access policies
  purge_protection_enabled     = true
  soft_delete_retention_days   = 90
  
  # Strict network access
  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []  # No public IP access
    virtual_network_subnet_ids = [
      module.subnet_app.subnet_id,
      module.subnet_admin.subnet_id
    ]
  }
  
  # Access policies
  policies = {
    # Admin access
    admin = {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id
      key_permissions = [
        "Get", "List", "Update", "Create", "Import", "Delete", "Recover",
        "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey",
        "Verify", "Sign", "Purge"
      ]
      secret_permissions = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
      certificate_permissions = [
        "Get", "List", "Update", "Create", "Import", "Delete", "Recover",
        "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers",
        "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"
      ]
      storage_permissions = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
      ]
    }
    
    # Application access
    application = {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azuread_service_principal.app_sp.object_id
      key_permissions = [
        "Get", "List", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign"
      ]
      secret_permissions = [
        "Get", "List"
      ]
      certificate_permissions = [
        "Get", "List"
      ]
      storage_permissions = []
    }
  }
  
  key_vault_tags = {
    Environment = "Production"
    Security    = "Premium"
    HSM         = "Enabled"
    Compliance  = "SOX"
  }
}
```

### Development Key Vault (Cost-Optimized)

```hcl
module "dev_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name      = "kv-myapp-dev-eastus2"
  resource_group_name = "rg-security-dev"
  location           = "East US 2"
  tenant_id          = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"  # Standard SKU for dev
  
  # Minimal features for dev
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = true
  
  # RBAC for simpler management
  enable_rbac_authorization    = true
  purge_protection_enabled     = false  # Allow purge for dev
  soft_delete_retention_days   = 7      # Minimum retention
  
  # Allow public access for development
  network_acls = {}
  
  key_vault_tags = {
    Environment   = "Development"
    CostOptimized = "True"
    AutoShutdown  = "Enabled"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |
| azuread | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |
| azuread | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.az_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|----------|---------|
| key_vault_name | Name of the Key Vault | `string` | `""` | ✅ | `"kv-myapp-prod-eastus2"` |
| resource_group_name | Name of the Resource Group | `string` | `""` | ✅ | `"rg-security-prod"` |
| location | Azure region for the Key Vault | `string` | `"westeurope"` | ✅ | `"East US 2"` |
| tenant_id | Azure AD tenant ID | `string` | `""` | ✅ | `data.azurerm_client_config.current.tenant_id` |
| sku_name | SKU name (standard or premium) | `string` | `"standard"` | ❌ | `"premium"` |
| enabled_for_deployment | Enable VM deployment access | `bool` | `null` | ❌ | `true` |
| enabled_for_disk_encryption | Enable disk encryption access | `bool` | `null` | ❌ | `true` |
| enabled_for_template_deployment | Enable ARM template access | `bool` | `null` | ❌ | `true` |
| enable_rbac_authorization | Use RBAC instead of access policies | `bool` | `false` | ❌ | `true` |
| purge_protection_enabled | Enable purge protection | `bool` | `false` | ❌ | `true` |
| soft_delete_retention_days | Soft delete retention period | `number` | `90` | ❌ | `90` |
| network_acls | Network access control rules | `object` | `{}` | ❌ | See network ACLs section |
| policies | Access policies configuration | `map(object)` | `{}` | ❌ | See access policies section |
| key_vault_tags | Tags for the Key Vault | `map(string)` | `{}` | ❌ | `{"Environment": "Production"}` |

### Network ACLs Configuration

```hcl
network_acls = {
  default_action = "Deny"                    # Allow or Deny
  bypass         = "AzureServices"           # AzureServices or None
  ip_rules       = ["203.0.113.0/24"]       # Allowed IP ranges
  virtual_network_subnet_ids = [            # Allowed subnet IDs
    "/subscriptions/.../subnets/subnet-app"
  ]
}
```

### Access Policies Configuration

```hcl
policies = {
  admin = {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = ["Get", "List", "Create", "Delete"]
    secret_permissions = ["Get", "List", "Set", "Delete"]
    certificate_permissions = ["Get", "List", "Create", "Delete"]
    storage_permissions = ["Get", "List", "Set", "Delete"]
  }
}
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| key_vault_id | The ID of the Key Vault | `string` |
| key_vault_name | The name of the Key Vault | `string` |
| key_vault_uri | The URI of the Key Vault | `string` |
| key_vault_vault_uri | The Vault URI of the Key Vault | `string` |

## Sub-Modules Usage

### Key Vault Secrets

```hcl
module "database_secrets" {
  source = "./Modules/AzureKeyVault/key_vault_secret"
  
  key_vault_id = module.key_vault.key_vault_id
  
  secrets = {
    "db-connection-string" = {
      name  = "db-connection-string"
      value = "Server=myserver;Database=mydb;User Id=myuser;Password=mypassword;"
      content_type = "Connection String"
      tags = {
        Purpose = "Database"
        Environment = "Production"
      }
    }
    
    "api-key" = {
      name  = "api-key"
      value = random_password.api_key.result
      content_type = "API Key"
      tags = {
        Purpose = "API"
        Service = "ThirdParty"
      }
    }
    
    "storage-account-key" = {
      name  = "storage-account-key"
      value = module.storage_account.primary_access_key
      content_type = "Storage Key"
      tags = {
        Purpose = "Storage"
        Account = module.storage_account.storage_account_name
      }
    }
  }
}
```

### Key Vault Keys

```hcl
module "encryption_keys" {
  source = "./Modules/AzureKeyVault/key_vault_key"
  
  key_vault_id = module.key_vault.key_vault_id
  
  keys = {
    "data-encryption-key" = {
      name     = "data-encryption-key"
      key_type = "RSA"
      key_size = 2048
      key_opts = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
      tags = {
        Purpose = "DataEncryption"
        Type    = "RSA"
      }
    }
    
    "app-signing-key" = {
      name     = "app-signing-key"
      key_type = "EC"
      curve    = "P-256"
      key_opts = ["sign", "verify"]
      tags = {
        Purpose = "CodeSigning"
        Type    = "ECC"
      }
    }
  }
}
```

### Key Vault Certificates

```hcl
module "ssl_certificates" {
  source = "./Modules/AzureKeyVault/key_vault_certificate"
  
  key_vault_id = module.key_vault.key_vault_id
  
  certificates = {
    "app-ssl-cert" = {
      name = "app-ssl-cert"
      
      certificate_policy = {
        issuer_parameters = {
          name = "Self"
        }
        
        key_properties = {
          exportable = true
          key_size   = 2048
          key_type   = "RSA"
          reuse_key  = true
        }
        
        lifetime_actions = [
          {
            action = {
              action_type = "AutoRenew"
            }
            trigger = {
              days_before_expiry = 30
            }
          }
        ]
        
        secret_properties = {
          content_type = "application/x-pkcs12"
        }
        
        x509_certificate_properties = {
          extended_key_usage = ["1.3.6.1.5.5.7.3.1"]  # Server Authentication
          key_usage = [
            "cRLSign",
            "dataEncipherment",
            "digitalSignature",
            "keyAgreement",
            "keyCertSign",
            "keyEncipherment"
          ]
          
          subject_alternative_names = {
            dns_names = ["myapp.example.com", "api.myapp.example.com"]
          }
          
          subject            = "CN=myapp.example.com"
          validity_in_months = 12
        }
      }
      
      tags = {
        Purpose = "SSL"
        Domain  = "myapp.example.com"
      }
    }
  }
}
```

## SKU Comparison

### Standard vs Premium SKUs

| Feature | Standard | Premium |
|---------|----------|---------|
| **Storage** | Software-protected keys | HSM-backed keys |
| **Key Types** | RSA, EC | RSA, EC, HSM |
| **Performance** | Standard | High performance |
| **Compliance** | Basic | FIPS 140-2 Level 2 |
| **Cost** | Lower | Higher |
| **Use Cases** | Development, general workloads | Production, compliance-required |

### When to Use Premium SKU

- ✅ Regulatory compliance requirements (FIPS 140-2 Level 2)
- ✅ High-security production environments
- ✅ Financial services or healthcare applications
- ✅ Government or defense contracts
- ✅ High-performance cryptographic operations

```hcl
# Premium Key Vault for compliance
module "compliance_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-compliance-prod"
  sku_name       = "premium"  # HSM-backed
  
  # Strict security settings
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
  
  # Network isolation
  network_acls = {
    default_action = "Deny"
    bypass         = "None"  # No bypass for compliance
    virtual_network_subnet_ids = [
      module.subnet_secure.subnet_id
    ]
  }
  
  tags = {
    Compliance = "FIPS-140-2-Level-2"
    HSM        = "Required"
    Security   = "Maximum"
  }
}
```

## Security Best Practices

### 1. Network Security

```hcl
# Secure Key Vault with private endpoint
module "secure_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-secure-prod-eastus2"
  # ... other configuration
  
  # Deny all public access
  network_acls = {
    default_action = "Deny"
    bypass         = "None"
    ip_rules       = []
    virtual_network_subnet_ids = []
  }
}

# Private endpoint for secure access
resource "azurerm_private_endpoint" "key_vault_pe" {
  name                = "pe-keyvault-secure"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.subnet_private.subnet_id
  
  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = module.secure_key_vault.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
```

### 2. Access Control with RBAC

```hcl
# Key Vault with RBAC authorization
module "rbac_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name            = "kv-rbac-prod-eastus2"
  enable_rbac_authorization = true
  # ... other configuration
}

# RBAC role assignments
resource "azurerm_role_assignment" "kv_admin" {
  scope                = module.rbac_key_vault.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.key_vault_admins.object_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = module.rbac_key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_service_principal.app.object_id
}

resource "azurerm_role_assignment" "kv_crypto_user" {
  scope                = module.rbac_key_vault.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = data.azuread_service_principal.app.object_id
}
```

### 3. Purge Protection and Soft Delete

```hcl
# Production Key Vault with maximum data protection
module "protected_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-protected-prod"
  
  # Enable all protection features
  purge_protection_enabled   = true   # Prevents permanent deletion
  soft_delete_retention_days = 90     # Maximum retention period
  
  tags = {
    DataProtection = "Maximum"
    BackupRequired = "True"
  }
}
```

## Integration Examples

### Integration with Application Services

```hcl
# Key Vault for web application
module "webapp_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name      = "kv-webapp-prod"
  resource_group_name = module.resource_group.az_resource_group_name
  location           = module.resource_group.az_resource_group_location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  
  enable_rbac_authorization = true
  
  # Network access for app subnet
  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
    virtual_network_subnet_ids = [
      module.subnet_app.subnet_id
    ]
  }
}

# App Service with Key Vault integration
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-myapp-prod"
  resource_group_name = module.resource_group.az_resource_group_name
  location           = module.resource_group.az_resource_group_location
  service_plan_id    = azurerm_service_plan.app_plan.id
  
  identity {
    type = "SystemAssigned"
  }
  
  app_settings = {
    "KEY_VAULT_URI" = module.webapp_key_vault.key_vault_uri
  }
  
  site_config {
    # Configuration
  }
}

# Grant app access to Key Vault
resource "azurerm_role_assignment" "webapp_kv_access" {
  scope                = module.webapp_key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}
```

### Integration with Virtual Machines

```hcl
# Key Vault enabled for VM deployment
module "vm_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-vm-prod"
  
  # Enable VM integrations
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  
  # VM certificates and secrets
  policies = {
    vm_service = {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azuread_service_principal.vm_sp.object_id
      secret_permissions = ["Get"]
      certificate_permissions = ["Get"]
    }
  }
}

# Virtual Machine with Key Vault certificate
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-app-prod"
  resource_group_name = var.resource_group_name
  location           = var.location
  size               = "Standard_D2s_v3"
  
  # Key Vault integration for certificates
  secret {
    certificate {
      url   = module.ssl_certificates.certificate_secret_id
      store = "My"
    }
    key_vault_id = module.vm_key_vault.key_vault_id
  }
  
  # Other VM configuration...
}
```

### Integration with Azure Disk Encryption

```hcl
# Key Vault for disk encryption
module "encryption_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-diskenc-prod"
  sku_name       = "premium"  # HSM for encryption
  
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  
  # Disk encryption key
  policies = {
    disk_encryption = {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azuread_service_principal.disk_encryption.object_id
      key_permissions = [
        "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "WrapKey", "UnwrapKey"
      ]
    }
  }
}

# Disk encryption set
resource "azurerm_disk_encryption_set" "disk_encryption" {
  name                = "des-vm-encryption"
  resource_group_name = var.resource_group_name
  location           = var.location
  key_vault_key_id   = module.encryption_keys.key_id
  
  identity {
    type = "SystemAssigned"
  }
}
```

## Monitoring and Auditing

### Key Vault Diagnostics

```hcl
# Diagnostic settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  name                       = "keyvault-diagnostics"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  enabled_log {
    category = "AuditEvent"
  }
  
  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
    
    retention_policy {
      enabled = true
      days    = 365  # Long retention for security audits
    }
  }
}

# Key Vault access alerts
resource "azurerm_monitor_metric_alert" "key_vault_access" {
  name                = "keyvault-unauthorized-access"
  resource_group_name = var.resource_group_name
  scopes              = [module.key_vault.key_vault_id]
  description         = "Alert on unauthorized Key Vault access attempts"
  
  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 5
    
    dimension {
      name     = "ResultType"
      operator = "Include"
      values   = ["Unauthorized"]
    }
  }
  
  action {
    action_group_id = var.security_action_group_id
  }
}
```

### Security Monitoring

```hcl
# Azure Sentinel integration for Key Vault
resource "azurerm_sentinel_data_connector_azure_key_vault" "kv_connector" {
  name                       = "keyvault-connector"
  log_analytics_workspace_id = var.sentinel_workspace_id
}

# Custom log analytics queries for security monitoring
resource "azurerm_log_analytics_saved_search" "kv_security_query" {
  name                       = "KeyVault-SecurityEvents"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  category                   = "Security"
  display_name              = "Key Vault Security Events"
  
  query = <<QUERY
KeyVaultData
| where TimeGenerated > ago(24h)
| where ResultType != "Success"
| summarize count() by CallerIpAddress, Identity, OperationName, ResultType
| order by count_ desc
QUERY
}
```

## Backup and Disaster Recovery

### Key Vault Backup Strategy

```hcl
# Backup automation for Key Vault secrets
resource "azurerm_automation_runbook" "key_vault_backup" {
  name                    = "KeyVault-Backup"
  location               = var.location
  resource_group_name    = var.resource_group_name
  automation_account_name = var.automation_account_name
  log_verbose            = true
  log_progress           = true
  runbook_type           = "PowerShell"
  
  content = file("${path.module}/scripts/backup-keyvault.ps1")
  
  tags = {
    Purpose = "Backup"
    Schedule = "Daily"
  }
}

# Schedule backup execution
resource "azurerm_automation_schedule" "key_vault_backup_schedule" {
  name                    = "daily-backup"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  frequency              = "Day"
  interval               = 1
  start_time             = "2025-01-01T02:00:00Z"
  description            = "Daily Key Vault backup"
}

# Link runbook to schedule
resource "azurerm_automation_job_schedule" "key_vault_backup_job" {
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  schedule_name          = azurerm_automation_schedule.key_vault_backup_schedule.name
  runbook_name           = azurerm_automation_runbook.key_vault_backup.name
}
```

### Multi-Region Key Vault Setup

```hcl
# Primary region Key Vault
module "primary_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-primary-prod-eastus2"
  location       = "East US 2"
  # ... configuration
  
  tags = {
    Region = "Primary"
    DR     = "Enabled"
  }
}

# Secondary region Key Vault for DR
module "secondary_key_vault" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-secondary-prod-westus2"
  location       = "West US 2"
  # ... configuration
  
  tags = {
    Region = "Secondary"
    DR     = "Replica"
  }
}
```

## Cost Optimization

### Key Vault Cost Factors

| Component | Cost Factor | Optimization Strategy |
|-----------|-------------|----------------------|
| Operations | API calls and transactions | Optimize application access patterns |
| HSM Operations | Premium SKU operations | Use only when compliance required |
| Certificate Renewals | Automated renewals | Use appropriate renewal periods |
| Network Costs | Private endpoints, data transfer | Optimize network architecture |

### Cost-Effective Configuration

```hcl
# Development Key Vault - cost optimized
module "dev_key_vault_optimized" {
  source = "./Modules/AzureKeyVault/key_vault"
  
  key_vault_name = "kv-dev-optimized"
  sku_name       = "standard"  # Avoid premium for dev
  
  # Minimal retention for cost savings
  soft_delete_retention_days = 7   # Minimum allowed
  purge_protection_enabled   = false  # Allow purge to save costs
  
  # No network restrictions (no private endpoint costs)
  network_acls = {}
  
  tags = {
    Environment   = "Development"
    CostOptimized = "True"
  }
}
```

## Troubleshooting

### Common Issues

#### 1. Access Denied Errors

```bash
Error: The user, group or application does not have access to the key vault
```

**Solution:** Check access policies or RBAC assignments.

```bash
# Check access policies
az keyvault show --name "kv-myapp-prod" --query "properties.accessPolicies"

# Check RBAC assignments
az role assignment list --scope "/subscriptions/.../resourceGroups/rg-security/providers/Microsoft.KeyVault/vaults/kv-myapp-prod"
```

#### 2. Network Access Issues

```bash
Error: The request is from a public network and the key vault has network restrictions
```

**Solution:** Add client IP to network ACLs or use private endpoint.

```bash
# Check network rules
az keyvault show --name "kv-myapp-prod" --query "properties.networkAcls"

# Add current IP to access rules
az keyvault network-rule add --name "kv-myapp-prod" --ip-address "$(curl -s ipinfo.io/ip)/32"
```

#### 3. Soft Delete Issues

```bash
Error: The key vault name is already in use
```

**Solution:** Recover or purge soft-deleted Key Vault.

```bash
# List soft-deleted Key Vaults
az keyvault list-deleted

# Recover soft-deleted Key Vault
az keyvault recover --name "kv-myapp-prod" --location "East US 2"

# Or purge permanently (if purge protection is disabled)
az keyvault purge --name "kv-myapp-prod" --location "East US 2"
```

### Validation Commands

```bash
# Check Key Vault status
az keyvault show --name "kv-myapp-prod" --resource-group "rg-security"

# Test secret access
az keyvault secret show --vault-name "kv-myapp-prod" --name "test-secret"

# Check certificate status
az keyvault certificate show --vault-name "kv-myapp-prod" --name "ssl-cert"

# Verify network connectivity
az keyvault network-rule list --name "kv-myapp-prod"

# Check access policies
az keyvault show --name "kv-myapp-prod" --query "properties.accessPolicies"
```

## Best Practices Summary

### 1. Security
- ✅ Use Premium SKU for production and compliance requirements
- ✅ Enable purge protection and appropriate soft delete retention
- ✅ Implement network access restrictions
- ✅ Use RBAC for modern access control
- ✅ Regular access reviews and cleanup

### 2. Access Control
- ✅ Follow principle of least privilege
- ✅ Use Azure AD groups for user access management
- ✅ Use managed identities for Azure services
- ✅ Regular audit of access policies and assignments

### 3. Monitoring
- ✅ Enable comprehensive diagnostic logging
- ✅ Set up security alerts for unauthorized access
- ✅ Integrate with Azure Sentinel for advanced monitoring
- ✅ Regular security assessments

### 4. Backup and Recovery
- ✅ Implement automated backup procedures
- ✅ Test recovery procedures regularly
- ✅ Consider multi-region setup for critical workloads
- ✅ Document recovery procedures

### 5. Cost Management
- ✅ Use Standard SKU when HSM is not required
- ✅ Optimize API call patterns in applications
- ✅ Right-size soft delete retention periods
- ✅ Regular cost reviews and optimization

## Example Implementation

See the [Example](./Example/) directory for complete implementation examples including:
- Basic Key Vault setup
- Advanced security configurations
- Integration with Azure services
- RBAC and access policy examples
- Monitoring and alerting setup

---

**Module Collection Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0, azuread ~> 2.0
