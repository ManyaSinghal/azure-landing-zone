# Management Resources Landing Zone

The Management Resources Landing Zone provides centralized management, monitoring, governance, and security services for the entire Azure Landing Zone implementation.

## 🏗️ Architecture Overview

The Management Resources Landing Zone serves as the operational foundation, providing:
- Centralized logging and monitoring
- Governance and compliance controls
- Security management and incident response
- Automation and operational tools
- Cost management and optimization
- Backup and disaster recovery coordination

## 📋 Resources Deployed

| Resource Type | Count | Purpose |
|---------------|-------|---------|
| Resource Groups | 2-4 | Logical grouping of management resources |
| Log Analytics Workspace | 1 | Centralized logging and monitoring |
| Application Insights | 1+ | Application performance monitoring |
| Automation Account | 1 | Runbook automation and configuration management |
| Recovery Services Vault | 1 | Backup and disaster recovery |
| Storage Accounts | 2+ | Diagnostic logs, automation artifacts |
| Key Vault | 1 | Secrets and certificate management |
| Azure Policy | Multiple | Governance and compliance enforcement |
| Management Groups | Multiple | Organizational hierarchy and policy assignment |

## 🔧 Configuration Variables

### terraform.tfvars Structure

The Management Resources Landing Zone uses the following configuration structure in `terraform.tfvars`:

### Resource Groups Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `resource_groups` | map(object) | Resource group definitions | ✅ | See example below |

#### Example Resource Groups Configuration

```hcl
resource_groups = {
  mgmt_rg1 = {
    resource_group_name = "rg-management-prod-monitoring"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Management"
      Purpose     = "Monitoring"
      CostCenter  = "IT-Operations"
      Owner       = "PlatformTeam"
    }
  }
  mgmt_rg2 = {
    resource_group_name = "rg-management-prod-governance"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Management"
      Purpose     = "Governance"
      CostCenter  = "IT-Operations"
    }
  }
  mgmt_rg3 = {
    resource_group_name = "rg-management-prod-security"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Management"
      Purpose     = "Security"
      CostCenter  = "IT-Security"
    }
  }
  mgmt_rg4 = {
    resource_group_name = "rg-management-prod-automation"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Management"
      Purpose     = "Automation"
      CostCenter  = "IT-Operations"
    }
  }
}
```

### Log Analytics Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `log_analytics_workspaces` | map(object) | Log Analytics workspace definitions | ✅ | See example below |

```hcl
log_analytics_workspaces = {
  central_logs = {
    name                = "law-management-prod-central"
    rg_key             = "mgmt_rg1"
    sku                = "PerGB2018"
    retention_in_days  = 90
    daily_quota_gb     = 50
    
    solutions = [
      "Security",
      "Updates",
      "ChangeTracking",
      "ServiceMap",
      "AzureActivity",
      "NetworkMonitoring",
      "SecurityInsights"
    ]
    
    saved_searches = {
      failed_logins = {
        name     = "Failed Login Attempts"
        category = "Security"
        query    = "SecurityEvent | where EventID == 4625 | summarize count() by Account, Computer"
      }
      resource_changes = {
        name     = "Resource Configuration Changes"
        category = "Governance"
        query    = "AzureActivity | where OperationName contains 'write' | project TimeGenerated, Caller, ResourceGroup, Resource"
      }
    }
  }
  
  security_logs = {
    name                = "law-management-prod-security"
    rg_key             = "mgmt_rg3"
    sku                = "PerGB2018"
    retention_in_days  = 180
    daily_quota_gb     = 20
    
    solutions = [
      "SecurityInsights",
      "Security",
      "AntiMalware"
    ]
  }
}
```

### Application Insights Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `application_insights` | map(object) | Application Insights definitions | ✅ | See example below |

```hcl
application_insights = {
  platform_insights = {
    name               = "appi-management-prod-platform"
    rg_key            = "mgmt_rg1"
    application_type  = "web"
    workspace_key     = "central_logs"
    
    daily_data_cap_in_gb                  = 10
    daily_data_cap_notifications_disabled = false
    retention_in_days                     = 90
    sampling_percentage                   = 100
    
    action_groups = {
      critical_alerts = {
        name = "Critical Application Alerts"
        email_receivers = [
          {
            name          = "PlatformTeam"
            email_address = "platform-team@company.com"
          }
        ]
      }
    }
  }
  
  workload_insights = {
    name               = "appi-management-prod-workloads"
    rg_key            = "mgmt_rg1"
    application_type  = "web"
    workspace_key     = "central_logs"
    retention_in_days = 30
  }
}
```

### Automation Account Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `automation_accounts` | map(object) | Automation Account definitions | ✅ | See example below |

```hcl
automation_accounts = {
  central_automation = {
    name               = "aa-management-prod-central"
    rg_key            = "mgmt_rg4"
    sku_name          = "Basic"
    workspace_key     = "central_logs"
    
    runbooks = {
      vm_start_stop = {
        name        = "StartStopVMs"
        type        = "PowerShell"
        description = "Start and stop VMs based on schedule"
        content     = file("${path.module}/runbooks/start-stop-vms.ps1")
        
        schedules = {
          start_vms = {
            name        = "StartVMsSchedule"
            frequency   = "Day"
            interval    = 1
            start_time  = "07:00:00"
            timezone    = "Eastern Standard Time"
          }
          stop_vms = {
            name        = "StopVMsSchedule"
            frequency   = "Day"
            interval    = 1
            start_time  = "19:00:00"
            timezone    = "Eastern Standard Time"
          }
        }
      }
      
      backup_verification = {
        name        = "BackupVerification"
        type        = "PowerShell"
        description = "Verify backup job status and alert on failures"
        content     = file("${path.module}/runbooks/backup-verification.ps1")
        
        schedules = {
          daily_check = {
            name       = "DailyBackupCheck"
            frequency  = "Day"
            interval   = 1
            start_time = "08:00:00"
          }
        }
      }
    }
    
    variables = {
      notification_email = {
        name  = "NotificationEmail"
        value = "platform-team@company.com"
      }
      environment = {
        name  = "Environment"
        value = "Production"
      }
    }
  }
}
```

### Recovery Services Vault Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `recovery_services_vaults` | map(object) | Recovery Services Vault definitions | ✅ | See example below |

```hcl
recovery_services_vaults = {
  central_backup = {
    name     = "rsv-management-prod-central"
    rg_key   = "mgmt_rg1"
    sku      = "Standard"
    
    backup_policies = {
      vm_daily_backup = {
        name     = "DailyVMBackup"
        type     = "Microsoft.RecoveryServices/vaults/backupPolicies"
        timezone = "Eastern Standard Time"
        
        backup = {
          frequency = "Daily"
          time      = "02:00"
        }
        
        retention_daily = {
          count = 30
        }
        
        retention_weekly = {
          count    = 12
          weekdays = ["Sunday"]
        }
        
        retention_monthly = {
          count    = 12
          weekdays = ["Sunday"]
          weeks    = ["First"]
        }
        
        retention_yearly = {
          count    = 5
          weekdays = ["Sunday"]
          weeks    = ["First"]
          months   = ["January"]
        }
      }
      
      file_share_backup = {
        name     = "DailyFileShareBackup"
        type     = "Microsoft.RecoveryServices/vaults/backupPolicies"
        timezone = "Eastern Standard Time"
        
        backup = {
          frequency = "Daily"
          time      = "03:00"
        }
        
        retention_daily = {
          count = 30
        }
      }
    }
  }
}
```

### Storage Accounts Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `storage_accounts` | map(object) | Storage account definitions | ✅ | See example below |

```hcl
storage_accounts = {
  diagnostic_storage = {
    name                     = "sadiagnosticprod001"
    rg_key                  = "mgmt_rg1"
    account_tier            = "Standard"
    account_replication_type = "GRS"
    account_kind            = "StorageV2"
    access_tier             = "Hot"
    
    enable_https_traffic_only = true
    min_tls_version          = "TLS1_2"
    allow_blob_public_access = false
    
    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices"]
      ip_rules       = ["203.0.113.0/24"]  # Office IP range
      virtual_network_subnet_ids = []
    }
    
    blob_properties = {
      delete_retention_policy = {
        days = 30
      }
      container_delete_retention_policy = {
        days = 30
      }
      versioning_enabled = true
    }
    
    containers = [
      {
        name        = "vm-diagnostics"
        access_type = "private"
      },
      {
        name        = "flow-logs"
        access_type = "private"
      },
      {
        name        = "audit-logs"
        access_type = "private"
      }
    ]
  }
  
  automation_storage = {
    name                     = "saautomationprod001"
    rg_key                  = "mgmt_rg4"
    account_tier            = "Standard"
    account_replication_type = "LRS"
    account_kind            = "StorageV2"
    
    containers = [
      {
        name        = "runbooks"
        access_type = "private"
      },
      {
        name        = "scripts"
        access_type = "private"
      }
    ]
  }
}
```

### Key Vault Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `key_vaults` | map(object) | Key Vault definitions | ✅ | See example below |

```hcl
key_vaults = {
  management_kv = {
    name     = "kv-management-prod-001"
    rg_key   = "mgmt_rg3"
    sku_name = "premium"
    
    enabled_for_disk_encryption     = true
    enabled_for_deployment          = true
    enabled_for_template_deployment = true
    enable_rbac_authorization      = true
    purge_protection_enabled       = true
    soft_delete_retention_days     = 90
    
    network_acls = {
      default_action = "Deny"
      bypass         = "AzureServices"
      ip_rules       = ["203.0.113.0/24"]
    }
    
    secrets = {
      automation_account_key = {
        name  = "AutomationAccountKey"
        value = "auto-generated-key"
      }
      notification_webhook = {
        name  = "NotificationWebhook"
        value = "https://hooks.slack.com/services/..."
      }
    }
    
    certificates = {
      management_ssl = {
        name = "management-ssl-certificate"
        certificate = {
          contents = filebase64("certificates/management.pfx")
          password = var.certificate_password
        }
      }
    }
  }
}
```

### Azure Policy Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `policy_definitions` | map(object) | Custom policy definitions | ✅ | See example below |

```hcl
policy_definitions = {
  require_tags = {
    name         = "require-mandatory-tags"
    display_name = "Require mandatory tags on resources"
    description  = "Enforces required tags on all resources"
    policy_type  = "Custom"
    mode         = "Indexed"
    
    policy_rule = jsonencode({
      if = {
        field = "type"
        in    = [
          "Microsoft.Compute/virtualMachines",
          "Microsoft.Storage/storageAccounts",
          "Microsoft.Network/virtualNetworks"
        ]
      }
      then = {
        effect = "deny"
        details = {
          type = "Microsoft.Authorization/policyAssignments"
          existenceCondition = {
            allOf = [
              {
                field  = "tags['Environment']"
                exists = "true"
              },
              {
                field  = "tags['CostCenter']"
                exists = "true"
              },
              {
                field  = "tags['Owner']"
                exists = "true"
              }
            ]
          }
        }
      }
    })
    
    parameters = jsonencode({
      tagNames = {
        type = "Array"
        metadata = {
          displayName = "Required Tag Names"
          description = "List of required tag names"
        }
        defaultValue = ["Environment", "CostCenter", "Owner"]
      }
    })
  }
  
  allowed_vm_sizes = {
    name         = "allowed-vm-sizes"
    display_name = "Allowed virtual machine size SKUs"
    description  = "Restricts VM sizes to approved SKUs"
    policy_type  = "Custom"
    mode         = "Indexed"
    
    policy_rule = jsonencode({
      if = {
        allOf = [
          {
            field = "type"
            equals = "Microsoft.Compute/virtualMachines"
          },
          {
            not = {
              field = "Microsoft.Compute/virtualMachines/sku.name"
              in    = "[parameters('allowedSKUs')]"
            }
          }
        ]
      }
      then = {
        effect = "deny"
      }
    })
  }
}

policy_assignments = {
  require_tags_assignment = {
    name                 = "require-tags-production"
    scope               = "/subscriptions/${var.subscription_id}"
    policy_definition_key = "require_tags"
    display_name        = "Require tags on production resources"
    description         = "Enforces mandatory tags on all production resources"
    
    parameters = jsonencode({
      tagNames = {
        value = ["Environment", "CostCenter", "Owner", "Workload"]
      }
    })
  }
}
```

### Management Groups Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `management_groups` | map(object) | Management group hierarchy | ✅ | See example below |

```hcl
management_groups = {
  root_mg = {
    name         = "mg-company-root"
    display_name = "Company Root Management Group"
    parent_id    = null
  }
  
  platform_mg = {
    name         = "mg-platform"
    display_name = "Platform Management Group"
    parent_id    = "mg-company-root"
  }
  
  workloads_mg = {
    name         = "mg-workloads"
    display_name = "Workloads Management Group"
    parent_id    = "mg-company-root"
  }
  
  corp_mg = {
    name         = "mg-corp"
    display_name = "Corporate Workloads"
    parent_id    = "mg-workloads"
  }
  
  online_mg = {
    name         = "mg-online"
    display_name = "Online Workloads"
    parent_id    = "mg-workloads"
  }
  
  sandbox_mg = {
    name         = "mg-sandbox"
    display_name = "Sandbox Environment"
    parent_id    = "mg-company-root"
  }
}
```

### Alert Rules Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `alert_rules` | map(object) | Monitoring alert definitions | ✅ | See example below |

```hcl
alert_rules = {
  high_cpu_usage = {
    name                = "HighCPUUsage"
    rg_key             = "mgmt_rg1"
    description        = "Alert when CPU usage is high"
    enabled            = true
    auto_mitigate      = true
    frequency          = "PT1M"
    window_size        = "PT5M"
    severity           = 2
    
    criteria = {
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 80
    }
    
    action_groups = ["critical_alerts"]
  }
  
  low_disk_space = {
    name                = "LowDiskSpace"
    rg_key             = "mgmt_rg1"
    description        = "Alert when disk space is low"
    enabled            = true
    frequency          = "PT5M"
    window_size        = "PT15M"
    severity           = 1
    
    criteria = {
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Disk Free Space %"
      aggregation      = "Average"
      operator         = "LessThan"
      threshold        = 10
    }
  }
  
  backup_failure = {
    name                = "BackupFailure"
    rg_key             = "mgmt_rg1"
    description        = "Alert when backup jobs fail"
    enabled            = true
    frequency          = "PT1H"
    window_size        = "PT1H"
    severity           = 1
    
    criteria = {
      query = "AzureDiagnostics | where Category == 'AzureBackupReport' | where OperationName == 'Backup' | where Result == 'Failed'"
      time_aggregation_method = "Count"
      operator               = "GreaterThan"
      threshold             = 0
    }
  }
}
```

### Subscription and Environment Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `subscription_id` | string | Target subscription for management resources | ✅ | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"` |
| `environment` | string | Environment identifier | ✅ | `"prod"` |
| `location` | string | Primary Azure region | ✅ | `"East US"` |
| `organization_name` | string | Organization identifier | ✅ | `"CompanyName"` |

## 🚀 Deployment Instructions

### Prerequisites

1. Azure CLI installed and configured
2. Terraform >= 1.0 installed
3. Appropriate Azure permissions (Owner or Contributor + User Access Administrator)
4. Management subscription prepared

### Step-by-Step Deployment

1. **Navigate to Management Resources Landing Zone**
   ```zsh
   cd landing_zones/management_resources
   ```

2. **Update Configuration**
   Edit `terraform.tfvars` with your specific values:
   ```zsh
   # Update subscription ID
   subscription_id = "your-management-subscription-id"
   
   # Update organization details
   organization_name = "your-organization"
   
   # Configure monitoring retention periods
   # Set up notification email addresses
   # Configure backup policies
   ```

3. **Initialize Terraform**
   ```zsh
   terraform init
   ```

4. **Plan Deployment**
   ```zsh
   terraform plan
   ```

5. **Apply Configuration**
   ```zsh
   terraform apply
   ```

### GitHub Actions Deployment

Deploy using the automated workflow:

```zsh
# Via GitHub CLI
gh workflow run "Deploy Selected Environment" \
  --field environment=management_resources \
  --field action=apply \
  --field import_enabled=false
```

### Post-Deployment Configuration

1. **Configure Data Collection Rules**
   ```zsh
   # Create data collection rules for VM monitoring
   az monitor data-collection-rule create \
     --resource-group rg-management-prod-monitoring \
     --name dcr-vm-monitoring \
     --location "East US" \
     --data-flows '[{
       "streams": ["Microsoft-Perf", "Microsoft-Event"],
       "destinations": ["law-management-prod-central"]
     }]'
   ```

2. **Set up Diagnostic Settings**
   ```zsh
   # Enable diagnostic settings for activity logs
   az monitor diagnostic-settings create \
     --name "ActivityLogs" \
     --resource "/subscriptions/$(az account show --query id -o tsv)" \
     --workspace "law-management-prod-central" \
     --logs '[{
       "category": "Administrative",
       "enabled": true,
       "retentionPolicy": {"days": 90, "enabled": true}
     }]'
   ```

3. **Configure Sentinel (if using)**
   ```zsh
   # Enable Azure Sentinel
   az sentinel workspace create \
     --resource-group rg-management-prod-security \
     --workspace-name law-management-prod-security
   ```

## 🔍 Post-Deployment Validation

### Verify Resources

```zsh
# Check resource groups
az group list --subscription <management-subscription-id> --output table

# Check Log Analytics workspaces
az monitor log-analytics workspace list \
  --subscription <management-subscription-id> \
  --output table

# Check automation accounts
az automation account list \
  --subscription <management-subscription-id> \
  --output table

# Check recovery services vaults
az backup vault list \
  --subscription <management-subscription-id> \
  --output table

# Check policy assignments
az policy assignment list --output table
```

### Test Monitoring and Alerting

```zsh
# Test Log Analytics connectivity
az monitor log-analytics query \
  --workspace "law-management-prod-central" \
  --analytics-query "Heartbeat | limit 10"

# Verify alert rules
az monitor metrics alert list \
  --resource-group rg-management-prod-monitoring \
  --output table

# Test automation runbooks
az automation runbook start \
  --automation-account-name aa-management-prod-central \
  --resource-group rg-management-prod-automation \
  --name "BackupVerification"
```

### Validate Governance

```zsh
# Check policy compliance
az policy state list \
  --subscription <subscription-id> \
  --query "[?complianceState=='NonCompliant']" \
  --output table

# Verify management group structure
az account management-group list --output table

# Test RBAC assignments
az role assignment list \
  --scope "/subscriptions/<subscription-id>" \
  --output table
```

## 📊 Monitoring and Governance Dashboards

### Log Analytics Workbooks

Create custom workbooks for comprehensive monitoring:

```json
{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AzureActivity\n| where TimeGenerated > ago(24h)\n| summarize count() by OperationName, bin(TimeGenerated, 1h)\n| render timechart",
        "size": 0,
        "title": "Azure Activity in Last 24 Hours"
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "SecurityEvent\n| where TimeGenerated > ago(24h)\n| where EventID in (4625, 4648, 4719)\n| summarize count() by EventID, bin(TimeGenerated, 1h)\n| render timechart",
        "size": 0,
        "title": "Security Events"
      }
    }
  ]
}
```

### Azure Dashboard Configuration

```hcl
dashboards = {
  operations_dashboard = {
    name     = "Operations Dashboard"
    rg_key   = "mgmt_rg1"
    location = "East US"
    
    dashboard_properties = jsonencode({
      lenses = {
        "0" = {
          order = 0
          parts = {
            "0" = {
              position = {
                x = 0
                y = 0
                rowSpan = 4
                colSpan = 6
              }
              metadata = {
                inputs = [
                  {
                    name = "resourceType"
                    value = "Microsoft.OperationalInsights/workspaces"
                  },
                  {
                    name = "resourceId"
                    value = "/subscriptions/${var.subscription_id}/resourceGroups/rg-management-prod-monitoring/providers/Microsoft.OperationalInsights/workspaces/law-management-prod-central"
                  }
                ]
                type = "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart"
              }
            }
          }
        }
      }
    })
  }
}
```

## 🔧 Operational Runbooks

### Backup Verification Runbook

```powershell
# backup-verification.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$VaultName
)

# Authenticate using Managed Identity
Connect-AzAccount -Identity

# Set subscription context
Set-AzContext -SubscriptionId $SubscriptionId

# Get backup jobs from last 24 hours
$jobs = Get-AzRecoveryServicesBackupJob -VaultId (Get-AzRecoveryServicesVault -ResourceGroupName $ResourceGroupName -Name $VaultName).ID -From (Get-Date).AddDays(-1)

# Check for failed jobs
$failedJobs = $jobs | Where-Object { $_.Status -eq "Failed" }

if ($failedJobs) {
    $message = "Backup failures detected:`n"
    foreach ($job in $failedJobs) {
        $message += "- Job: $($job.JobId), Workload: $($job.WorkloadName), Error: $($job.ErrorDetails)`n"
    }
    
    # Send notification
    $webhook = Get-AutomationVariable -Name "NotificationWebhook"
    $body = @{
        text = $message
        channel = "#operations"
        username = "Azure Automation"
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
}

Write-Output "Backup verification completed. Found $($failedJobs.Count) failed jobs."
```

### Resource Cleanup Runbook

```powershell
# resource-cleanup.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$false)]
    [int]$RetentionDays = 7
)

Connect-AzAccount -Identity
Set-AzContext -SubscriptionId $SubscriptionId

# Find unused disks
$unusedDisks = Get-AzDisk | Where-Object { $_.DiskState -eq "Unattached" -and $_.TimeCreated -lt (Get-Date).AddDays(-$RetentionDays) }

# Find unused NICs
$unusedNics = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null -and $_.TimeCreated -lt (Get-Date).AddDays(-$RetentionDays) }

# Find unused Public IPs
$unusedPips = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null -and $_.TimeCreated -lt (Get-Date).AddDays(-$RetentionDays) }

$report = @"
Resource Cleanup Report:
- Unused Disks: $($unusedDisks.Count)
- Unused NICs: $($unusedNics.Count)
- Unused Public IPs: $($unusedPips.Count)

Cleanup recommended for resources older than $RetentionDays days.
"@

Write-Output $report

# Optionally remove resources (uncomment for automated cleanup)
# $unusedDisks | Remove-AzDisk -Force
# $unusedNics | Remove-AzNetworkInterface -Force
# $unusedPips | Remove-AzPublicIpAddress -Force
```

## 🔒 Security and Compliance

### Governance Controls

- **Azure Policy**: Enforce organizational standards and compliance
- **Management Groups**: Hierarchical organization structure
- **RBAC**: Role-based access control at all levels
- **Resource Locks**: Prevent accidental deletion of critical resources
- **Cost Management**: Budget alerts and spending controls

### Security Monitoring

- **Security Center**: Centralized security posture management
- **Sentinel**: SIEM/SOAR capabilities for advanced threat detection
- **Key Vault**: Secure storage for secrets, keys, and certificates
- **Audit Logging**: Comprehensive audit trail for all activities
- **Vulnerability Assessment**: Regular security assessments

### Compliance Features

- **Regulatory Compliance**: Built-in compliance dashboards
- **Data Residency**: Regional data placement controls
- **Encryption**: End-to-end encryption for data protection
- **Backup and Recovery**: Business continuity planning
- **Incident Response**: Automated incident detection and response

## 🚨 Troubleshooting

### Common Issues

| Issue | Symptoms | Resolution |
|-------|----------|------------|
| Log Analytics Data Missing | No data in queries | Check diagnostic settings and data collection rules |
| Automation Runbook Failures | Runbook execution errors | Verify managed identity permissions and dependencies |
| Policy Assignment Conflicts | Resources blocked unexpectedly | Review policy definitions and exemptions |
| Backup Job Failures | Backup operations failing | Check Recovery Services Vault permissions and connectivity |
| Alert Rule Not Triggering | No alerts despite conditions met | Verify metric names and thresholds |

### Debug Commands

```zsh
# Check Log Analytics data ingestion
az monitor log-analytics query \
  --workspace "law-management-prod-central" \
  --analytics-query "union * | summarize count() by Type | order by count_ desc"

# Verify automation account permissions
az automation account show \
  --name aa-management-prod-central \
  --resource-group rg-management-prod-automation

# Check policy state
az policy state list \
  --subscription <subscription-id> \
  --filter "policyDefinitionId eq '/subscriptions/<sub-id>/providers/Microsoft.Authorization/policyDefinitions/require-tags'"

# Test backup vault connectivity
az backup vault backup-properties show \
  --vault-name rsv-management-prod-central \
  --resource-group rg-management-prod-monitoring

# Verify alert rule configuration
az monitor metrics alert show \
  --name "HighCPUUsage" \
  --resource-group rg-management-prod-monitoring
```

## 🔄 Maintenance and Operations

### Regular Tasks

- **Review and update policies**: Monthly policy review and updates
- **Monitor cost trends**: Weekly cost analysis and optimization
- **Backup verification**: Daily backup job status verification
- **Security assessment**: Monthly security posture review
- **Capacity planning**: Quarterly resource utilization analysis

### Automation Schedule

```hcl
automation_schedules = {
  daily_operations = {
    name        = "DailyOperations"
    frequency   = "Day"
    interval    = 1
    start_time  = "06:00:00"
    timezone    = "Eastern Standard Time"
    
    runbooks = [
      "BackupVerification",
      "SecurityComplianceCheck",
      "ResourceHealthCheck"
    ]
  }
  
  weekly_cleanup = {
    name        = "WeeklyCleanup"
    frequency   = "Week"
    interval    = 1
    week_days   = ["Sunday"]
    start_time  = "02:00:00"
    
    runbooks = [
      "ResourceCleanup",
      "LogArchival",
      "CostOptimization"
    ]
  }
  
  monthly_reporting = {
    name        = "MonthlyReporting"
    frequency   = "Month"
    interval    = 1
    monthly_occurrences = [1]
    start_time  = "01:00:00"
    
    runbooks = [
      "MonthlyComplianceReport",
      "CostAnalysisReport",
      "SecurityPostureReport"
    ]
  }
}
```

## 📈 Cost Optimization

### Cost Management Configuration

```hcl
budgets = {
  management_budget = {
    name   = "Management Resources Budget"
    amount = 5000
    time_grain = "Monthly"
    
    notifications = [
      {
        enabled        = true
        operator       = "GreaterThan"
        threshold      = 80
        contact_emails = ["finance@company.com", "platform-team@company.com"]
        contact_groups = ["BudgetAlerts"]
        contact_roles  = ["Owner", "Contributor"]
      }
    ]
    
    filters = {
      resource_groups = [
        "rg-management-prod-monitoring",
        "rg-management-prod-governance",
        "rg-management-prod-security",
        "rg-management-prod-automation"
      ]
    }
  }
  
  overall_landing_zone_budget = {
    name   = "Landing Zone Overall Budget"
    amount = 50000
    time_grain = "Monthly"
    
    notifications = [
      {
        enabled        = true
        operator       = "GreaterThan"
        threshold      = 90
        contact_emails = ["cfo@company.com", "platform-team@company.com"]
      }
    ]
  }
}
```

## 🤝 Dependencies

This landing zone should be deployed first as other landing zones depend on:

- Log Analytics workspaces for diagnostic data
- Automation accounts for operational tasks
- Recovery Services Vaults for backup services
- Key Vaults for certificate and secret storage
- Policy definitions for governance enforcement

## 📋 Outputs

The Management Resources Landing Zone provides these outputs:

| Output | Description | Usage |
|--------|-------------|-------|
| `log_analytics_workspace_id` | Central Log Analytics workspace ID | For diagnostic settings in other landing zones |
| `automation_account_id` | Automation account resource ID | For runbook deployment and management |
| `recovery_services_vault_id` | Backup vault resource ID | For VM and file share backup configuration |
| `key_vault_id` | Management Key Vault resource ID | For certificate and secret storage |
| `storage_account_ids` | Storage account resource IDs | For diagnostic logs and automation artifacts |
| `policy_definition_ids` | Custom policy definition IDs | For policy assignments across landing zones |
| `management_group_ids` | Management group resource IDs | For organizational hierarchy management |

This comprehensive Management Resources Landing Zone provides the operational foundation needed to effectively manage, monitor, and govern your entire Azure Landing Zone implementation.
