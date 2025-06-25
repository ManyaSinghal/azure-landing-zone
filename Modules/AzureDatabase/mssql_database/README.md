# Azure SQL Database Module

This Terraform module creates and manages an Azure SQL Database with comprehensive configuration options including performance tiers, backup policies, auditing, and elastic pool support.

## Features

- **Performance Tiers**: Support for Basic, Standard, Premium, and vCore-based SKUs
- **Backup & Recovery**: Configurable short-term and long-term retention policies
- **Security**: Database auditing and extended auditing policies
- **Scalability**: Elastic pool integration and auto-scaling capabilities
- **High Availability**: Zone redundancy and read scale options
- **Compliance**: Ledger-enabled databases for tamper-evident storage

## Usage

### Basic SQL Database

```hcl
module "sql_database" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name   = "myapp-db"
  server_id = module.sql_server.server_id
  sku_name  = "S0"

  mssql_db_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Production SQL Database with Advanced Features

```hcl
module "sql_database_prod" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name          = "myapp-prod-db"
  server_id        = module.sql_server.server_id
  sku_name         = "P2"
  max_size_gb      = 500
  zone_redundant   = true
  read_scale       = true
  license_type     = "BasePrice"
  
  # Backup configuration
  short_term_retention_days = 14
  
  # Auditing configuration
  enable_auditing          = true
  audit_storage_endpoint   = module.storage_account.primary_blob_endpoint
  audit_storage_key        = module.storage_account.primary_access_key
  audit_retention_days     = 365
  
  # Security features
  ledger_enabled = true
  enclave_type   = "VBS"

  mssql_db_tags = {
    Environment = "production"
    Project     = "myapp"
    Tier        = "database"
    Backup      = "required"
  }
}
```

### Serverless SQL Database

```hcl
module "sql_database_serverless" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name                     = "myapp-serverless-db"
  server_id                   = module.sql_server.server_id
  sku_name                    = "GP_S_Gen5_1"
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5

  mssql_db_tags = {
    Environment = "dev"
    Type        = "serverless"
  }
}
```

### Elastic Pool Database

```hcl
module "sql_database_elastic" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name         = "myapp-elastic-db"
  server_id       = module.sql_server.server_id
  sku_name        = "ElasticPool"
  elastic_pool_id = module.elastic_pool.pool_id

  mssql_db_tags = {
    Environment = "production"
    Pool        = "shared"
  }
}
```

## Module Configuration

### Input Variables

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `db_name` | `string` | - | ✅ | The name of the MSSQL database |
| `server_id` | `string` | - | ✅ | The ID of the SQL server |
| `sku_name` | `string` | - | ✅ | The SKU for the SQL database (e.g., S0, P1, GP_S_Gen5_2) |
| `collation` | `string` | `"SQL_Latin1_General_CP1_CI_AS"` | ❌ | The collation for the database |
| `license_type` | `string` | `"LicenseIncluded"` | ❌ | License type: LicenseIncluded or BasePrice |
| `max_size_gb` | `number` | `5` | ❌ | The maximum size in GB |
| `read_scale` | `string` | `true` | ❌ | Whether read scale is enabled |
| `zone_redundant` | `bool` | `false` | ❌ | Whether zone redundancy is enabled |
| `enclave_type` | `string` | `null` | ❌ | Enclave type (e.g., VBS) |
| `ledger_enabled` | `bool` | `false` | ❌ | Enable ledger functionality |
| `storage_account_type` | `string` | `"Geo"` | ❌ | Storage account type for backups |
| `auto_pause_delay_in_minutes` | `number` | `null` | ❌ | Auto-pause delay for serverless databases |
| `min_capacity` | `number` | `null` | ❌ | Minimum capacity for serverless databases |
| `short_term_retention_days` | `number` | `null` | ❌ | Short-term backup retention in days |
| `elastic_pool_id` | `string` | `null` | ❌ | Elastic pool ID if database is in a pool |
| `enable_auditing` | `bool` | `false` | ❌ | Enable database auditing |
| `audit_storage_endpoint` | `string` | `null` | ❌ | Storage endpoint for audit logs |
| `audit_storage_key` | `string` | `null` | ❌ | Storage access key for audit logs |
| `audit_retention_days` | `number` | `90` | ❌ | Audit log retention in days |
| `mssql_db_tags` | `map(string)` | `{}` | ❌ | Tags to assign to the database |

### Output Values

| Name | Description |
|------|-------------|
| `database_id` | The ID of the SQL database |
| `database_name` | The name of the SQL database |

## SKU Options

### DTU-Based SKUs

| Tier | SKU | DTUs | Max Size | Use Case |
|------|-----|------|----------|----------|
| Basic | `Basic` | 5 | 2 GB | Development/Testing |
| Standard | `S0` | 10 | 250 GB | Light workloads |
| Standard | `S1` | 20 | 250 GB | Small applications |
| Standard | `S2` | 50 | 250 GB | Medium applications |
| Premium | `P1` | 125 | 500 GB | Mission-critical apps |
| Premium | `P2` | 250 | 500 GB | High-performance apps |
| Premium | `P4` | 500 | 500 GB | Large applications |

### vCore-Based SKUs

| Tier | SKU Example | vCores | Memory | Use Case |
|------|-------------|--------|--------|----------|
| General Purpose | `GP_Gen5_2` | 2 | 10.4 GB | Balanced workloads |
| General Purpose | `GP_Gen5_4` | 4 | 20.8 GB | Medium workloads |
| Business Critical | `BC_Gen5_2` | 2 | 10.4 GB | Low latency, high IOPS |
| Hyperscale | `HS_Gen5_2` | 2 | 10.4 GB | Large databases (100TB+) |

### Serverless SKUs

| SKU | Min vCores | Max vCores | Memory | Use Case |
|-----|------------|------------|--------|----------|
| `GP_S_Gen5_1` | 0.5 | 1 | 3 GB | Development |
| `GP_S_Gen5_2` | 0.5 | 2 | 6 GB | Light workloads |
| `GP_S_Gen5_4` | 0.5 | 4 | 12 GB | Variable workloads |

## Security Features

### Database Auditing

```hcl
# Enable comprehensive auditing
enable_auditing          = true
audit_storage_endpoint   = "https://mystorageaccount.blob.core.windows.net/"
audit_storage_key        = var.storage_account_key
audit_retention_days     = 365
```

### Ledger Database

```hcl
# Enable tamper-evident ledger
ledger_enabled = true
```

### Always Encrypted with Secure Enclaves

```hcl
# Enable secure enclaves
enclave_type = "VBS"
```

## Backup and Recovery

### Short-term Backup Retention

```hcl
# Configure point-in-time restore
short_term_retention_days = 35  # 7-35 days
```

### Geo-Redundant Storage

```hcl
# Configure backup storage type
storage_account_type = "Geo"     # Local, Geo, Zone
```

## Performance Optimization

### Read Scale-Out

```hcl
# Enable read replicas for Premium/Business Critical
read_scale = true
```

### Zone Redundancy

```hcl
# Enable high availability across zones
zone_redundant = true
```

### Serverless Auto-Scaling

```hcl
# Configure serverless scaling
sku_name                    = "GP_S_Gen5_2"
auto_pause_delay_in_minutes = 60
min_capacity                = 0.5
```

## Integration Examples

### With Elastic Pool

```hcl
# First create the elastic pool
module "elastic_pool" {
  source = "./path/to/elastic_pool"
  
  pool_name   = "myapp-pool"
  server_id   = module.sql_server.server_id
  sku_name    = "StandardPool"
  per_database_settings = {
    min_capacity = 0
    max_capacity = 50
  }
}

# Then add databases to the pool
module "database_in_pool" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name         = "pooled-db"
  server_id       = module.sql_server.server_id
  sku_name        = "ElasticPool"
  elastic_pool_id = module.elastic_pool.pool_id
}
```

### With Application Gateway and Key Vault

```hcl
# Database with connection string in Key Vault
module "sql_database" {
  source = "./Modules/AzureDatabase/mssql_database"

  db_name   = "myapp-db"
  server_id = module.sql_server.server_id
  sku_name  = "S2"
}

# Store connection string securely
resource "azurerm_key_vault_secret" "db_connection" {
  name         = "database-connection-string"
  value        = "Server=${module.sql_server.fqdn};Database=${module.sql_database.database_name};..."
  key_vault_id = module.key_vault.key_vault_id
}
```

## Monitoring and Alerts

### Enable Diagnostic Settings

```hcl
# Configure database metrics and logs
resource "azurerm_monitor_diagnostic_setting" "database" {
  name                       = "database-diagnostics"
  target_resource_id         = module.sql_database.database_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "DatabaseWaitStatistics"
  }

  enabled_log {
    category = "Errors"
  }

  metric {
    category = "Basic"
    enabled  = true
  }
}
```

## Cost Optimization

### DTU vs vCore Pricing

- **DTU Model**: Simpler, bundled pricing for predictable workloads
- **vCore Model**: More granular control, better for variable workloads
- **Serverless**: Pay-per-use, ideal for intermittent workloads

### License Benefits

```hcl
# Use existing SQL Server licenses
license_type = "BasePrice"  # Up to 55% savings with Azure Hybrid Benefit
```

### Right-Sizing

```hcl
# Start small and scale up
sku_name    = "S0"  # Start with Standard S0
max_size_gb = 10    # Start with minimal storage
```

## Troubleshooting

### Common Issues

1. **Connection Timeouts**
   ```bash
   # Check firewall rules on SQL Server
   az sql server firewall-rule list --server <server-name> --resource-group <rg-name>
   ```

2. **Performance Issues**
   ```bash
   # Monitor DTU utilization
   az monitor metrics list --resource <database-id> --metric "dtu_consumption_percent"
   ```

3. **Storage Limits**
   ```bash
   # Check current database size
   az sql db show --name <db-name> --server <server-name> --resource-group <rg-name>
   ```

### Validation Commands

```bash
# Verify database creation
az sql db show --name <db-name> --server <server-name> --resource-group <rg-name>

# Check database status
az sql db list --server <server-name> --resource-group <rg-name> --query "[?name=='<db-name>'].status"

# Verify backup configuration
az sql db str-policy show --name <db-name> --server <server-name> --resource-group <rg-name>

# Test database connectivity
sqlcmd -S <server-name>.database.windows.net -d <db-name> -U <username> -P <password> -Q "SELECT @@VERSION"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Dependencies

- SQL Server must exist before creating database
- Storage account required for auditing (if enabled)
- Key Vault recommended for secrets management

## Best Practices

1. **Always use Azure Hybrid Benefit** for cost savings with existing licenses
2. **Enable auditing** for production databases
3. **Use zone redundancy** for mission-critical workloads
4. **Implement proper backup retention** policies
5. **Monitor performance metrics** and set up alerts
6. **Use serverless** for development and intermittent workloads
7. **Consider elastic pools** for multiple databases with variable usage

## Related Modules

- [mssql_server](../mssql_server/README.md) - SQL Server configuration
- [AzureStorage](../../AzureStorage/README.md) - Storage for backups and auditing
- [AzureKeyVault](../../AzureKeyVault/README.md) - Secrets management
- [AzureMonitor](../../AzureMonitor/README.md) - Monitoring and alerting
