# Azure SQL Server Module

This Terraform module creates and manages an Azure SQL Server with comprehensive security features, identity management, and networking configurations.

## Features

- **Security**: TLS enforcement, firewall rules, and Azure AD integration
- **Identity Management**: System-assigned and user-assigned managed identities
- **Network Security**: Private endpoints and network access restrictions
- **Compliance**: Auditing policies and threat detection
- **High Availability**: Geo-redundant configurations and failover groups

## Usage

### Basic SQL Server

```hcl
module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-sql-server"
  resource_group_name = "myapp-rg"
  location            = "East US"
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password

  mssql_server_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Production SQL Server with Security Features

```hcl
module "sql_server_prod" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-prod-sql-server"
  resource_group_name = "myapp-prod-rg"
  location            = "East US"
  server_version      = "12.0"
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password

  # Security configuration
  minimum_tls_version                   = "1.2"
  public_network_access_enabled         = false
  outbound_network_restriction_enabled  = true
  
  # Managed identity
  identity_type = "SystemAssigned"

  mssql_server_tags = {
    Environment = "production"
    Project     = "myapp"
    Tier        = "database"
    Security    = "high"
  }
}
```

### SQL Server with User-Assigned Identity

```hcl
# Create user-assigned identity first
resource "azurerm_user_assigned_identity" "sql_identity" {
  name                = "sql-server-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "sql_server_uai" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-uai-sql-server"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password

  # User-assigned identity
  identity_type = "UserAssigned"

  mssql_server_tags = {
    Environment = "production"
    Identity    = "user-assigned"
  }
}
```

## Module Configuration

### Input Variables

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `server_name` | `string` | - | ✅ | The name of the SQL server |
| `resource_group_name` | `string` | - | ✅ | The name of the resource group |
| `location` | `string` | - | ✅ | The Azure region location |
| `admin_login` | `string` | - | ✅ | The administrator login name |
| `admin_password` | `string` | - | ✅ | The administrator password (sensitive) |
| `server_version` | `string` | `"12.0"` | ❌ | The version of the SQL server |
| `identity_type` | `string` | `"SystemAssigned"` | ❌ | Managed identity type |
| `minimum_tls_version` | `string` | `"1.2"` | ❌ | Minimum TLS version |
| `public_network_access_enabled` | `bool` | `true` | ❌ | Enable public network access |
| `outbound_network_restriction_enabled` | `bool` | `false` | ❌ | Enable outbound network restrictions |
| `mssql_server_tags` | `map(string)` | `{}` | ❌ | Tags to assign to the server |

### Output Values

| Name | Description |
|------|-------------|
| `az_mssql_server_id` | The ID of the Microsoft SQL Server |
| `az_mssql_server_name` | The name of the Microsoft SQL Server |
| `az_mssql_server_administrator_login` | The server's administrator login name |
| `az_mssql_server_fully_qualified_domain_name` | The FQDN of the Azure SQL Server |
| `az_mssql_server_restorable_dropped_database_ids` | List of dropped restorable database IDs |

## Server Versions

| Version | Description | Support Status |
|---------|-------------|----------------|
| `12.0` | SQL Server 2014 | ✅ Supported |
| `11.0` | SQL Server 2012 | ⚠️ Legacy |
| `10.0` | SQL Server 2008 | ❌ Deprecated |

## Security Configuration

### TLS Enforcement

```hcl
# Enforce TLS 1.2 minimum
minimum_tls_version = "1.2"
```

### Network Access Control

```hcl
# Disable public access for production
public_network_access_enabled = false

# Enable outbound restrictions
outbound_network_restriction_enabled = true
```

### Managed Identity Types

```hcl
# System-assigned identity (recommended)
identity_type = "SystemAssigned"

# User-assigned identity
identity_type = "UserAssigned"

# Both system and user-assigned
identity_type = "SystemAssigned, UserAssigned"
```

## Advanced Configurations

### With Private Endpoint

```hcl
module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name                   = "myapp-private-sql"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_login                   = "sqladmin"
  admin_password                = var.sql_admin_password
  public_network_access_enabled = false

  mssql_server_tags = {
    Environment = "production"
    Access      = "private"
  }
}

# Create private endpoint
resource "azurerm_private_endpoint" "sql_server" {
  name                = "sql-server-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "sql-server-psc"
    private_connection_resource_id = module.sql_server.az_mssql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
```

### With Firewall Rules

```hcl
module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-sql-server"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password
}

# Allow Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = module.sql_server.az_mssql_server_id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow specific IP range
resource "azurerm_mssql_firewall_rule" "office" {
  name             = "AllowOfficeNetwork"
  server_id        = module.sql_server.az_mssql_server_id
  start_ip_address = "203.0.113.0"
  end_ip_address   = "203.0.113.255"
}
```

### With Azure AD Authentication

```hcl
module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-aad-sql"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password
  identity_type       = "SystemAssigned"
}

# Configure Azure AD admin
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "example" {
  server_id                    = module.sql_server.az_mssql_server_id
  enabled                      = true
  storage_endpoint             = var.audit_storage_endpoint
  storage_account_access_key   = var.audit_storage_key
}

# Set Azure AD administrator
data "azuread_user" "sql_admin" {
  user_principal_name = "sql-admin@company.com"
}

resource "azurerm_mssql_server_extended_auditing_policy" "example" {
  server_id                               = module.sql_server.az_mssql_server_id
  enabled                                 = true
  storage_endpoint                        = var.audit_storage_endpoint
  storage_account_access_key              = var.audit_storage_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 365
}
```

## Security Features

### Auditing Configuration

```hcl
# Enable server-level auditing
resource "azurerm_mssql_server_extended_auditing_policy" "server_audit" {
  server_id                               = module.sql_server.az_mssql_server_id
  enabled                                 = true
  storage_endpoint                        = azurerm_storage_account.audit.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.audit.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 365
}
```

### Threat Detection

```hcl
# Enable Advanced Threat Protection
resource "azurerm_mssql_server_security_alert_policy" "threat_detection" {
  resource_group_name = var.resource_group_name
  server_name         = module.sql_server.az_mssql_server_name
  state               = "Enabled"
  
  disabled_alerts = []
  
  email_account_admins = true
  email_addresses      = ["security@company.com"]
  
  retention_days = 30
  
  storage_account_access_key = azurerm_storage_account.security.primary_access_key
  storage_endpoint          = azurerm_storage_account.security.primary_blob_endpoint
}
```

### Vulnerability Assessment

```hcl
# Configure vulnerability assessment
resource "azurerm_mssql_server_vulnerability_assessment" "va" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.threat_detection.id
  storage_container_path          = "${azurerm_storage_account.security.primary_blob_endpoint}vulnerability-assessment/"
  storage_account_access_key      = azurerm_storage_account.security.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = ["security@company.com"]
  }
}
```

## Integration Examples

### Complete Setup with Key Vault

```hcl
# Store admin password in Key Vault
data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  key_vault_id = var.key_vault_id
}

module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-secure-sql"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_login         = "sqladmin"
  admin_password      = data.azurerm_key_vault_secret.sql_admin_password.value
  
  # Security best practices
  minimum_tls_version                   = "1.2"
  public_network_access_enabled         = false
  outbound_network_restriction_enabled  = true
  identity_type                         = "SystemAssigned"

  mssql_server_tags = {
    Environment = "production"
    Security    = "high"
    Backup      = "required"
  }
}

# Grant Key Vault access to SQL Server identity
resource "azurerm_key_vault_access_policy" "sql_server" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.sql_server.az_mssql_server_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}
```

### High Availability Setup

```hcl
# Primary SQL Server
module "sql_server_primary" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-sql-primary"
  resource_group_name = "myapp-primary-rg"
  location            = "East US"
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password
  identity_type       = "SystemAssigned"

  mssql_server_tags = {
    Role = "primary"
    HA   = "enabled"
  }
}

# Secondary SQL Server for failover
module "sql_server_secondary" {
  source = "./Modules/AzureDatabase/mssql_server"

  server_name         = "myapp-sql-secondary"
  resource_group_name = "myapp-secondary-rg"
  location            = "West US"
  admin_login         = "sqladmin"
  admin_password      = var.sql_admin_password
  identity_type       = "SystemAssigned"

  mssql_server_tags = {
    Role = "secondary"
    HA   = "enabled"
  }
}

# Failover group
resource "azurerm_mssql_failover_group" "ha" {
  name      = "myapp-failover-group"
  server_id = module.sql_server_primary.az_mssql_server_id

  databases = [
    azurerm_mssql_database.primary.id
  ]

  partner_server {
    id = module.sql_server_secondary.az_mssql_server_id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
```

## Monitoring and Alerts

### Diagnostic Settings

```hcl
resource "azurerm_monitor_diagnostic_setting" "sql_server" {
  name                       = "sql-server-diagnostics"
  target_resource_id         = module.sql_server.az_mssql_server_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "DevOpsOperationsAudit"
  }

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "Basic"
    enabled  = true
  }
}
```

### Performance Alerts

```hcl
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "sql-server-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [module.sql_server.az_mssql_server_id]
  description         = "SQL Server CPU usage alert"

  criteria {
    metric_namespace = "Microsoft.Sql/servers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = var.action_group_id
  }
}
```

## Troubleshooting

### Common Issues

1. **Connection Failures**
   ```bash
   # Check firewall rules
   az sql server firewall-rule list --server <server-name> --resource-group <rg-name>
   
   # Test connectivity
   telnet <server-name>.database.windows.net 1433
   ```

2. **Authentication Issues**
   ```bash
   # Verify admin credentials
   az sql server show --name <server-name> --resource-group <rg-name>
   
   # Check Azure AD integration
   az sql server ad-admin list --server <server-name> --resource-group <rg-name>
   ```

3. **Network Access**
   ```bash
   # Check network configuration
   az sql server show --name <server-name> --resource-group <rg-name> --query publicNetworkAccess
   
   # List private endpoints
   az network private-endpoint list --resource-group <rg-name>
   ```

### Validation Commands

```bash
# Verify server creation
az sql server show --name <server-name> --resource-group <rg-name>

# Check server status
az sql server list --resource-group <rg-name> --query "[?name=='<server-name>'].state"

# Test SQL connection
sqlcmd -S <server-name>.database.windows.net -U <admin-login> -P <password> -Q "SELECT @@VERSION"

# Verify identity configuration
az sql server show --name <server-name> --resource-group <rg-name> --query identity

# Check TLS configuration
az sql server show --name <server-name> --resource-group <rg-name> --query minimalTlsVersion
```

## Best Practices

1. **Security**
   - Always use TLS 1.2 or higher
   - Disable public access for production
   - Use Azure AD authentication when possible
   - Enable auditing and threat detection

2. **Identity Management**
   - Use system-assigned managed identity
   - Grant minimal required permissions
   - Rotate credentials regularly

3. **Network Security**
   - Use private endpoints for production
   - Implement proper firewall rules
   - Enable outbound restrictions

4. **Monitoring**
   - Enable diagnostic settings
   - Set up performance alerts
   - Monitor security events

5. **High Availability**
   - Consider failover groups for critical workloads
   - Use geo-redundant backups
   - Test disaster recovery procedures

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Dependencies

- Resource Group must exist
- Storage Account required for auditing
- Key Vault recommended for password management
- Virtual Network required for private endpoints

## Related Modules

- [mssql_database](../mssql_database/README.md) - SQL Database configuration
- [AzureStorage](../../AzureStorage/README.md) - Storage for auditing
- [AzureKeyVault](../../AzureKeyVault/README.md) - Secrets management
- [AzureNetwork](../../AzureNetwork/README.md) - Private networking