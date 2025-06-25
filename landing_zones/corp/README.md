# Corp Landing Zone

The Corp Landing Zone is designed for hosting corporate workloads that require strict governance, compliance, and connectivity to on-premises environments.

## 🏗️ Architecture Overview

The Corp Landing Zone implements the spoke component in a hub-and-spoke architecture, providing:
- Secure network connectivity to the Platform Landing Zone hub
- Governance and compliance controls
- Corporate workload hosting environment
- Integration with on-premises Active Directory

## 📋 Resources Deployed

| Resource Type | Count | Purpose |
|---------------|-------|---------|
| Resource Groups | 1-3 | Logical grouping of corp resources |
| Virtual Networks | 1+ | Corp workload networking |
| Subnets | Multiple | Workload segmentation |
| Network Security Groups | Multiple | Network access control |
| VNet Peering | 1+ | Connectivity to hub |
| Route Tables | Multiple | Traffic routing through hub |

## 🔧 Configuration Variables

### terraform.tfvars Structure

The Corp Landing Zone uses the following configuration structure in `terraform.tfvars`:

### Resource Groups Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `resource_groups` | map(object) | Resource group definitions | ✅ | See example below |

#### Example Resource Groups Configuration

```hcl
resource_groups = {
  corp_rg1 = {
    resource_group_name = "rg-corp-prod-workloads"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Corporate"
      CostCenter  = "IT"
      Owner       = "CorpIT"
    }
  }
  corp_rg2 = {
    resource_group_name = "rg-corp-prod-data"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Corporate"
      DataClass   = "Confidential"
      CostCenter  = "IT"
    }
  }
}
```

### Networking Configuration

#### Virtual Networks

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `corp_virtual_networks` | map(object) | VNet definitions for corp workloads | ✅ | See example below |

```hcl
corp_virtual_networks = {
  corp_vnet1 = {
    virtual_network_name = "vnet-corp-prod-01"
    rg_key               = "corp_rg1"
    vnet_address_space   = ["10.1.0.0/16"]
    dns_servers          = ["10.15.1.4", "10.15.1.5"]  # Platform domain controllers
  }
  corp_vnet2 = {
    virtual_network_name = "vnet-corp-data-01"
    rg_key               = "corp_rg2"
    vnet_address_space   = ["10.2.0.0/16"]
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
  }
}
```

#### Subnets

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `corp_subnets` | map(object) | Subnet definitions | ✅ | See example below |

```hcl
corp_subnets = {
  corp_web_subnet = {
    vnet_key                    = "corp_vnet1"
    rg_key                      = "corp_rg1"
    subnet_name                 = "snet-corp-web"
    subnet_address_prefix       = ["10.1.1.0/24"]
    network_security_group_name = "nsg-corp-web"
    route_table_name           = "rt-corp-web"
    service_endpoints          = ["Microsoft.Storage", "Microsoft.KeyVault"]
  }
  corp_app_subnet = {
    vnet_key                    = "corp_vnet1"
    rg_key                      = "corp_rg1"
    subnet_name                 = "snet-corp-app"
    subnet_address_prefix       = ["10.1.2.0/24"]
    network_security_group_name = "nsg-corp-app"
    route_table_name           = "rt-corp-app"
    service_endpoints          = ["Microsoft.Sql", "Microsoft.Storage"]
  }
  corp_data_subnet = {
    vnet_key                    = "corp_vnet2"
    rg_key                      = "corp_rg2"
    subnet_name                 = "snet-corp-data"
    subnet_address_prefix       = ["10.2.1.0/24"]
    network_security_group_name = "nsg-corp-data"
    route_table_name           = "rt-corp-data"
    service_endpoints          = ["Microsoft.Sql"]
  }
}
```

#### Network Security Groups

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `corp_nsg` | map(object) | NSG definitions with security rules | ✅ | See example below |

```hcl
corp_nsg = {
  nsg_corp_web = {
    name     = "nsg-corp-web"
    rg_key   = "corp_rg1"
    nsg_rules = {
      allow_https_inbound = {
        name                       = "AllowHTTPS"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.0.0.0/8"  # Internal only
        destination_address_prefix = "*"
      }
      allow_http_inbound = {
        name                       = "AllowHTTP"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
      }
      deny_internet_outbound = {
        name                       = "DenyInternetOutbound"
        priority                   = 4000
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
      }
    }
  }
  nsg_corp_app = {
    name     = "nsg-corp-app"
    rg_key   = "corp_rg1"
    nsg_rules = {
      allow_web_tier = {
        name                       = "AllowFromWebTier"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.1.1.0/24"  # Web subnet
        destination_address_prefix = "*"
      }
      deny_internet_outbound = {
        name                       = "DenyInternetOutbound"
        priority                   = 4000
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
      }
    }
  }
  nsg_corp_data = {
    name     = "nsg-corp-data"
    rg_key   = "corp_rg2"
    nsg_rules = {
      allow_app_tier = {
        name                       = "AllowFromAppTier"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.1.2.0/24"  # App subnet
        destination_address_prefix = "*"
      }
      deny_all_inbound = {
        name                       = "DenyAllInbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}
```

#### Route Tables

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `corp_route_tables` | map(object) | Route table definitions | ✅ | See example below |

```hcl
corp_route_tables = {
  rt_corp_web = {
    name   = "rt-corp-web"
    rg_key = "corp_rg1"
    routes = {
      default_route = {
        name                   = "DefaultToFirewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type         = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"  # Azure Firewall IP from platform
      }
      onprem_route = {
        name                   = "OnPremisesTraffic"
        address_prefix         = "192.168.0.0/16"
        next_hop_type         = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"
      }
    }
  }
  rt_corp_app = {
    name   = "rt-corp-app"
    rg_key = "corp_rg1"
    routes = {
      default_route = {
        name                   = "DefaultToFirewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type         = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"
      }
    }
  }
}
```

### VNet Peering Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `vnet_peerings` | map(object) | VNet peering to platform hub | ✅ | See example below |

```hcl
vnet_peerings = {
  corp_to_platform = {
    peering_name                      = "peer-corp-to-platform"
    vnet_name                        = "vnet-corp-prod-01"
    remote_vnet_id                   = "/subscriptions/<platform-sub>/resourceGroups/TreyResearch-connectivity/providers/Microsoft.Network/virtualNetworks/vnet-platform-prod-01"
    rg_key                           = "corp_rg1"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways             = true
  }
  corp_data_to_platform = {
    peering_name                      = "peer-corp-data-to-platform"
    vnet_name                        = "vnet-corp-data-01"
    remote_vnet_id                   = "/subscriptions/<platform-sub>/resourceGroups/TreyResearch-connectivity/providers/Microsoft.Network/virtualNetworks/vnet-platform-prod-01"
    rg_key                           = "corp_rg2"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways             = true
  }
}
```

### Subscription and Environment Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `corp_subscription_id` | string | Target subscription for corp resources | ✅ | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"` |
| `platform_subscription_id` | string | Platform subscription for peering | ✅ | `"yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"` |
| `environment` | string | Environment identifier | ✅ | `"prod"` |
| `location` | string | Primary Azure region | ✅ | `"East US"` |

## 🚀 Deployment Instructions

### Prerequisites

1. **Platform Landing Zone** must be deployed first
2. Azure CLI installed and configured
3. Terraform >= 1.0 installed
4. Appropriate permissions in both corp and platform subscriptions

### Step-by-Step Deployment

1. **Navigate to Corp Landing Zone**
   ```bash
   cd landing_zones/corp
   ```

2. **Update Configuration**
   Edit `terraform.tfvars` with your specific values:
   ```bash
   # Update subscription IDs
   corp_subscription_id = "your-corp-subscription-id"
   platform_subscription_id = "your-platform-subscription-id"
   
   # Update network addressing to avoid conflicts
   # Update resource names and locations
   # Configure NSG rules for your security requirements
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Plan Deployment**
   ```bash
   terraform plan
   ```

5. **Apply Configuration**
   ```bash
   terraform apply
   ```

### Post-Deployment Configuration

1. **Configure VNet Peering from Platform Side**
   ```bash
   # This may need to be done in the platform subscription
   az network vnet peering create \
     --name peer-platform-to-corp \
     --vnet-name vnet-platform-prod-01 \
     --remote-vnet "/subscriptions/<corp-sub>/resourceGroups/rg-corp-prod-workloads/providers/Microsoft.Network/virtualNetworks/vnet-corp-prod-01" \
     --allow-vnet-access \
     --allow-forwarded-traffic \
     --allow-gateway-transit
   ```

2. **Verify Connectivity**
   ```bash
   # Test name resolution to platform domain controllers
   # Test connectivity through Azure Firewall
   # Verify route table effectiveness
   ```

## 🔍 Post-Deployment Validation

### Verify Resources

```bash
# Check resource groups
az group list --subscription <corp-subscription-id> --output table

# Check virtual networks
az network vnet list --subscription <corp-subscription-id> --output table

# Check VNet peering status
az network vnet peering list --vnet-name vnet-corp-prod-01 --resource-group rg-corp-prod-workloads --output table

# Check route tables
az network route-table list --subscription <corp-subscription-id> --output table
```

### Network Connectivity Tests

```bash
# Test connectivity to platform hub
ping 10.0.1.4  # Azure Firewall IP

# Test DNS resolution
nslookup corporate.domain.com

# Test internet connectivity (should go through firewall)
curl -I https://www.google.com
```

## 🔧 Customization Examples

### Adding New Workload Subnets

```hcl
corp_subnets = {
  # ...existing subnets...
  
  corp_analytics_subnet = {
    vnet_key                    = "corp_vnet1"
    rg_key                      = "corp_rg1"
    subnet_name                 = "snet-corp-analytics"
    subnet_address_prefix       = ["10.1.10.0/24"]
    network_security_group_name = "nsg-corp-analytics"
    route_table_name           = "rt-corp-analytics"
    service_endpoints          = ["Microsoft.Storage", "Microsoft.Sql"]
  }
}
```

### Custom Security Rules for Different Workloads

```hcl
# Example for SQL Server subnet
nsg_corp_sql = {
  name     = "nsg-corp-sql"
  rg_key   = "corp_rg2"
  nsg_rules = {
    allow_sql_from_app = {
      name                       = "AllowSQLFromApp"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "10.1.2.0/24"  # App subnet
      destination_address_prefix = "*"
    }
    allow_sql_backup = {
      name                       = "AllowSQLBackup"
      priority                   = 1010
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "Storage"
    }
    deny_all_other_inbound = {
      name                       = "DenyAllOtherInbound"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
```

## 🔒 Security and Compliance

### Network Security

- **Deny Internet by Default**: All subnets have deny internet outbound rules
- **Hub-Spoke Security**: All traffic routed through Azure Firewall in platform
- **Micro-segmentation**: Each workload tier has its own subnet and NSG
- **Service Endpoints**: Used for secure access to Azure PaaS services

### Compliance Features

- **Traffic Inspection**: All traffic flows through centralized firewall
- **Audit Logging**: Network flow logs and NSG logs enabled
- **Data Classification**: Resource tags indicate data sensitivity
- **Network Isolation**: Strict network boundaries between workload tiers

### Recommended Security Practices

1. **Implement Least Privilege**: NSG rules should be as restrictive as possible
2. **Use Service Endpoints**: For accessing Azure PaaS services securely
3. **Enable Diagnostic Logs**: For all network resources
4. **Regular Security Reviews**: Periodically review NSG rules and routes
5. **Network Monitoring**: Implement network monitoring and alerting

## 📊 Monitoring and Logging

### Key Metrics to Monitor

| Metric | Resource Type | Threshold | Action |
|--------|--------------|-----------|---------|
| NSG Flow Logs | NSG | Monitor for anomalies | Investigate unusual patterns |
| Route Table Changes | Route Tables | Any change | Alert security team |
| VNet Peering Status | VNet Peering | Down | Immediate investigation |
| DNS Resolution Failures | VNet | > 5% failure rate | Check domain controllers |

### Diagnostic Settings

Enable diagnostic settings for:
- Network Security Groups (flow logs)
- Route Tables (activity logs)
- Virtual Networks (activity logs)
- VNet Peering (activity logs)

## 🚨 Troubleshooting

### Common Issues

| Issue | Symptoms | Resolution |
|-------|----------|------------|
| VNet Peering Failed | Cannot reach platform resources | Check peering configuration and permissions |
| DNS Resolution Issues | Cannot resolve domain names | Verify DNS server configuration |
| Connectivity Issues | Cannot reach internet/on-premises | Check route tables and firewall rules |
| NSG Rule Conflicts | Unexpected traffic blocking | Review NSG rule priorities and conflicts |

### Debug Commands

```bash
# Check effective routes
az network nic show-effective-route-table --ids <nic-id>

# Check effective NSG rules
az network nic list-effective-nsg --ids <nic-id>

# Test connectivity
az network watcher test-connectivity --source-resource <vm-id> --dest-address <target-ip>

# Check VNet peering status
az network vnet peering show --name <peering-name> --vnet-name <vnet-name> --resource-group <rg-name>
```

## 🔄 Maintenance

### Regular Tasks

- Review and update NSG rules
- Monitor network traffic patterns
- Update route tables as needed
- Review VNet peering status
- Update resource tags

### Scaling Considerations

- Plan IP address space expansion
- Consider additional VNets for workload isolation
- Monitor bandwidth utilization
- Plan for additional subnets as workloads grow

## 📈 Best Practices

### Network Design

1. **Plan IP Address Space**: Ensure no overlap with platform or other spokes
2. **Use Consistent Naming**: Follow naming conventions for all resources
3. **Implement Defense in Depth**: Multiple layers of security controls
4. **Document Network Flows**: Maintain network flow documentation

### Operational Excellence

1. **Infrastructure as Code**: All changes through Terraform
2. **Change Management**: Follow formal change processes
3. **Monitoring and Alerting**: Comprehensive monitoring strategy
4. **Disaster Recovery**: Plan for network disaster recovery

## 🤝 Dependencies

### Platform Landing Zone Dependencies

- Azure Firewall IP address for route tables
- Platform VNet IDs for peering
- Domain controller IPs for DNS configuration
- Platform subscription access for peering

### External Dependencies

- Azure AD tenant for identity integration
- On-premises network configuration
- Corporate security policies and compliance requirements

## 📋 Outputs

The Corp Landing Zone provides these outputs:

| Output | Description | Usage |
|--------|-------------|-------|
| `corp_vnet_ids` | Corp VNet resource IDs | For additional peering or workload deployment |
| `corp_subnet_ids` | Corp subnet resource IDs | For VM and service deployment |
| `corp_nsg_ids` | NSG resource IDs | For additional rule management |
| `corp_route_table_ids` | Route table resource IDs | For additional route management |
