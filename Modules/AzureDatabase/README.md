# Azure Database Module

This comprehensive module collection provides Terraform modules for creating and managing Azure Database services including SQL Server, SQL Database, and related database infrastructure components.

## Overview

Azure Database services provide fully managed, secure, and scalable database solutions in the cloud. This module collection offers a complete set of components to build secure, high-performance, and cost-effective database solutions in Azure, supporting SQL Server with advanced security, backup, and monitoring features.

## Module Structure

```
AzureDatabase/
├── mssql_server/                # SQL Server creation and management
│   ├── main.tf                 # Main SQL Server resource
│   ├── variables.tf            # Variable definitions
│   ├── output.tf              # Output values
│   ├── versions.tf            # Provider requirements
│   └── README.md              # SQL Server module documentation
└── mssql_database/             # SQL Database creation and management
    ├── main.tf                 # Main SQL Database resource
    ├── variables.tf            # Variable definitions
    ├── output.tf              # Output values
    ├── versions.tf            # Provider requirements
    └── README.md              # SQL Database module documentation
```

## Features

- ✅ Azure SQL Server with multiple authentication options
- ✅ Azure SQL Database with various service tiers
- ✅ Advanced security features (TDE, Always Encrypted, ATP)
- ✅ High availability and disaster recovery options
- ✅ Automated backups and point-in-time restore
- ✅ Elastic pools for cost optimization
- ✅ Network security and private endpoints
- ✅ Monitoring and performance insights
- ✅ Compliance and auditing features
- ✅ Managed identity integration

## Quick Start

### Basic SQL Server and Database

```hcl
# SQL Server
module "sql_server" {
  source = "./Modules/AzureDatabase/mssql_server"
  
  server_name         = "sql-myapp-prod-eastus2"
  resource_group_name = "rg-database-prod"
  location           = "East US 2"
  server_version     = "12.0"
  
  # Authentication
  admin_login    = "sqladmin"
  admin_password = var.sql_admin_password  # Use Key Vault reference
  
  # Security settings
  minimum_tls_version              = "1.2"
  public_network_access_enabled    = false
  outbound_network_restriction_enabled = true
  
  # Enable managed identity
  identity_type = "SystemAssigned"
  
  mssql_server_tags = {
    Environment = "Production"
    Service     = "Database"
    Owner       = "Data Team"
    Backup      = "Required"
  }
}

# SQL Database
module "sql_database" {
  source = "./Modules/AzureDatabase/mssql_database"
  
  db_name   = "db-myapp-prod"
  server_id = module.sql_server.mssql_server_id
  
  # Performance tier
  sku_name = "GP_S_Gen5_2"  # General Purpose Serverless
  
  # Database settings
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 100
  
  # High availability
  zone_redundant = true
  read_scale     = true
  
  mssql_database_tags = {
    Environment = "Production"
    Application = "MyApp"
    DataTier    = "Primary"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Sub-Modules

- [**mssql_server**](./mssql_server/) - Azure SQL Server creation and management
- [**mssql_database**](./mssql_database/) - Azure SQL Database creation and management

## SQL Database Service Tiers

### vCore-Based Tiers

#### General Purpose
| SKU | vCores | Memory | Max Size | Use Case |
|-----|--------|--------|----------|----------|
| GP_Gen5_2 | 2 | 10.4 GB | 32 GB - 4 TB | Balanced compute and memory |
| GP_Gen5_4 | 4 | 20.8 GB | 32 GB - 4 TB | Medium workloads |
| GP_Gen5_8 | 8 | 41.5 GB | 32 GB - 4 TB | Large workloads |

#### Business Critical
| SKU | vCores | Memory | Max Size | Use Case |
|-----|--------|--------|----------|----------|
| BC_Gen5_2 | 2 | 10.4 GB | 32 GB - 4 TB | Low latency, high IOPS |
| BC_Gen5_4 | 4 | 20.8 GB | 32 GB - 4 TB | Mission-critical apps |
| BC_Gen5_8 | 8 | 41.5 GB | 32 GB - 4 TB | High-performance workloads |

### DTU-Based Tiers

| Tier | SKU | DTUs | Max Size | Use Case |
|------|-----|------|----------|----------|
| Basic | Basic | 5 | 2 GB | Development, testing |
| Standard | S0-S12 | 10-3000 | 250 GB - 1 TB | Small to large workloads |
| Premium | P1-P15 | 125-4000 | 500 GB - 4 TB | Mission-critical workloads |

## Architecture Patterns

### Single Database Pattern

```hcl
# Production single database setup
module "production_setup" {
  source = "./examples/single-database"
  
  environment         = "production"
  application_name    = "ecommerce"
  database_tier      = "BusinessCritical"
  backup_retention   = "LongTerm"
  geo_replication    = true
}
```

### Multi-Database with Elastic Pool

```hcl
# Multi-tenant application with elastic pool
module "multitenant_setup" {
  source = "./examples/elastic-pool"
  
  tenant_databases   = ["tenant1", "tenant2", "tenant3"]
  pool_configuration = "standard"
  cost_optimization  = true
}
```

### Microservices Database Pattern

```hcl
# Separate databases per microservice
module "microservices_databases" {
  source = "./examples/microservices"
  
  services = {
    "user-service"    = { tier = "GeneralPurpose", size = "S2" }
    "order-service"   = { tier = "GeneralPurpose", size = "S3" }
    "payment-service" = { tier = "BusinessCritical", size = "P1" }
  }
}
```

## Security Best Practices

### Network Security

```hcl
# Private endpoint configuration
resource "azurerm_private_endpoint" "sql_pe" {
  name                = "pe-sql-prod"
  location           = var.location
  resource_group_name = var.resource_group_name
  subnet_id          = var.database_subnet_id
  
  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = module.sql_server.mssql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
```

### Authentication and Authorization

```hcl
# Azure AD authentication
resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  server_id                               = module.sql_server.mssql_server_id
  storage_endpoint                        = var.audit_storage_endpoint
  storage_account_access_key              = var.audit_storage_key
  retention_in_days                       = 90
  log_monitoring_enabled                  = true
}
```

## High Availability Options

### Zone Redundancy

```hcl
# Zone redundant database
module "ha_database" {
  source = "./Modules/AzureDatabase/mssql_database"
  
  db_name        = "db-ha-prod"
  server_id      = module.sql_server.mssql_server_id
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
  
  tags = {
    HighAvailability = "ZoneRedundant"
  }
}
```

### Geo-Replication

```hcl
# Primary and secondary databases
module "geo_replication" {
  source = "./examples/geo-replication"
  
  primary_region   = "East US 2"
  secondary_region = "West US 2"
  failover_policy  = "Automatic"
}
```

## Cost Optimization

### Serverless Databases

```hcl
# Serverless for variable workloads
module "serverless_db" {
  source = "./Modules/AzureDatabase/mssql_database"
  
  db_name  = "db-dev-serverless"
  server_id = module.sql_server.mssql_server_id
  sku_name = "GP_S_Gen5_1"
  
  auto_pause_delay_in_minutes = 60
  min_capacity               = 0.5
  max_capacity               = 2
}
```

### Reserved Capacity

```hcl
# Reserved instances for predictable workloads
locals {
  cost_analysis = {
    payg_monthly    = 1500
    reserved_1_year = 1050
    reserved_3_year = 750
  }
}
```

## Monitoring and Performance

### Performance Monitoring

```hcl
# Database performance insights
resource "azurerm_monitor_diagnostic_setting" "db_diagnostics" {
  name                       = "database-performance"
  target_resource_id         = module.sql_database.mssql_database_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  enabled_log {
    category = "QueryStoreRuntimeStatistics"
  }
  
  enabled_log {
    category = "QueryStoreWaitStatistics"  
  }
  
  metric {
    category = "Basic"
    enabled  = true
  }
}
```

### Alerting

```hcl
# Performance alerts
module "database_alerts" {
  source = "./examples/monitoring"
  
  database_id     = module.sql_database.mssql_database_id
  alert_threshold = {
    dtu_percent = 80
    cpu_percent = 85
    deadlocks   = 5
  }
}
```

## Backup and Recovery

### Automated Backups

```hcl
# Long-term retention policy
resource "azurerm_mssql_database_backup_long_term_retention_policy" "ltr" {
  database_id        = module.sql_database.mssql_database_id
  weekly_retention   = "P12W"
  monthly_retention  = "P12M"
  yearly_retention   = "P7Y"
  week_of_year      = 1
}
```

### Point-in-Time Restore

```hcl
# Restore capability
module "database_restore" {
  source = "./examples/restore"
  
  source_database_id = module.sql_database.mssql_database_id
  restore_point      = "2025-06-24T12:00:00Z"
  target_server_id   = module.sql_server.mssql_server_id
}
```

## Compliance and Auditing

### Data Protection

```hcl
# Transparent Data Encryption
module "data_encryption" {
  source = "./examples/encryption"
  
  server_id         = module.sql_server.mssql_server_id
  key_vault_key_id  = var.customer_managed_key_id
  encryption_type   = "CustomerManaged"
}
```

### Audit Logging

```hcl
# Comprehensive auditing
module "database_auditing" {
  source = "./examples/auditing"
  
  server_id           = module.sql_server.mssql_server_id
  audit_storage_account = var.audit_storage_account
  retention_days      = 365
  compliance_standard = "SOX"
}
```

## Integration Examples

### Application Integration

```hcl
# Web app with SQL connection
module "app_integration" {
  source = "./examples/app-integration"
  
  app_service_name    = "webapp-myapp"
  sql_server_id      = module.sql_server.mssql_server_id
  database_name      = module.sql_database.mssql_database_name
  connection_security = "ManagedIdentity"
}
```

### Data Factory Integration

```hcl
# ETL pipeline integration
module "data_pipeline" {
  source = "./examples/data-factory"
  
  source_database_id = module.sql_database.mssql_database_id
  target_storage_account = var.data_lake_storage
  pipeline_schedule = "Daily"
}
```

## Troubleshooting

### Common Issues

1. **Connection Issues**: Check firewall rules and private endpoints
2. **Performance**: Monitor DTU/vCore usage and query performance
3. **Storage**: Monitor database growth and implement retention policies
4. **Security**: Verify TLS versions and audit configurations

### Diagnostic Commands

```bash
# Check SQL Server status
az sql server show --name "sql-myapp-prod" --resource-group "rg-database"

# List databases
az sql db list --server "sql-myapp-prod" --resource-group "rg-database"

# Check metrics
az monitor metrics list --resource-group "rg-database" \
  --resource "Microsoft.Sql/servers/sql-myapp-prod/databases/db-myapp"
```

## Best Practices

### Security
- ✅ Use Azure AD authentication
- ✅ Enable Transparent Data Encryption
- ✅ Implement network isolation
- ✅ Regular security assessments

### Performance
- ✅ Choose appropriate service tier
- ✅ Monitor query performance
- ✅ Use read replicas for read-heavy workloads
- ✅ Implement proper indexing strategies

### Cost Management
- ✅ Use serverless for variable workloads
- ✅ Consider elastic pools for multiple databases
- ✅ Implement data retention policies
- ✅ Monitor and optimize resource usage

### High Availability
- ✅ Enable zone redundancy
- ✅ Configure geo-replication for DR
- ✅ Regular backup testing
- ✅ Monitor failover capabilities

## Examples

- [Single Database](./examples/single-database/) - Basic database setup
- [High Availability](./examples/high-availability/) - Multi-zone deployment
- [Disaster Recovery](./examples/disaster-recovery/) - Geo-replication setup
- [Cost Optimization](./examples/cost-optimization/) - Serverless and elastic pools
- [Security Hardening](./examples/security/) - Advanced security features

---

**Module Collection Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0