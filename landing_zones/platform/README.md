# Platform Landing Zone

The Platform Landing Zone serves as the central hub in the Azure Landing Zone architecture, providing shared services and connectivity for all other landing zones.

## 🏗️ Architecture Overview

The Platform Landing Zone implements the hub component of a hub-and-spoke network topology, containing:
- Shared networking infrastructure
- Centralized connectivity services
- Identity and domain services
- Management and monitoring resources

## 📋 Resources Deployed

| Resource Type | Count | Purpose |
|---------------|-------|---------|
| Resource Groups | 3 | Logical grouping of resources |
| Virtual Networks | 2 | Hub networking infrastructure |
| Subnets | Multiple | Network segmentation |
| Network Security Groups | Multiple | Network access control |
| Azure Firewall | 1 | Centralized security |
| VPN/ExpressRoute Gateway | Optional | Hybrid connectivity |
| Domain Controllers | Optional | Identity services |
| Log Analytics Workspace | 1 | Centralized monitoring |
| Automation Account | 1 | Management automation |

## 🔧 Configuration Variables

### Resource Groups Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `resource_groups` | map(object) | Resource group definitions | ✅ | See example below |

#### Example Resource Groups Configuration

```hcl
resource_groups = {
  rg1 = {
    resource_group_name = "TreyResearch-mgmt"
    location            = "Canada Central"
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg2 = {
    resource_group_name = "TreyResearch-connectivity"
    location            = "Canada Central"
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
  rg3 = {
    resource_group_name = "TreyResearch-identity"
    location            = "Canada Central"
    rg_tags = {
      CostCenter = "None"
      Env        = "Prod"
    }
  }
}
```

### Management Resources Configuration

| Variable | Type | Description | Required | Default | Example |
|----------|------|-------------|----------|---------|---------|
| `log_analytics_workspace` | string | Log Analytics workspace name | ✅ | - | `"log-treyresearch-prod-001"` |
| `automation_account_name` | string | Automation account name | ✅ | - | `"auto-treyresearch-prod-001"` |
| `platform_subscription_id` | string | Target subscription ID | ✅ | - | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"` |

### Networking Configuration

#### Virtual Networks

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `platform_virtual_network` | map(object) | Virtual network definitions | ✅ | See example below |

```hcl
platform_virtual_network = {
  vnet1 = {
    virtual_network_name = "vnet-platform-prod-01"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    rg_key               = "rg2"
    vnet_address_space   = ["10.0.0.0/16"]
  }
  vnet2 = {
    virtual_network_name = "vnet-prod-usw-01"
    rg_key               = "rg3"
    dns_servers          = ["10.15.1.4", "10.15.1.5"]
    vnet_address_space   = ["10.15.0.0/16"]
  }
}
```

#### Subnets

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `platform_subnets` | map(object) | Subnet definitions | ✅ | See example below |

```hcl
platform_subnets = {
  snet1 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.1.0/24"]
    subnet_name                   = "snet-platform-connectivity"
    network_security_group_name   = "nsg-platform-connectivity"
    route_table_name             = "rt-platform-connectivity"
  }
  snet2 = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.2.0/24"]
    subnet_name                   = "GatewaySubnet"
    network_security_group_name   = ""
    route_table_name             = ""
  }
}
```

#### Network Security Groups

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `platform_nsg` | map(object) | NSG definitions with rules | ✅ | See example below |

```hcl
platform_nsg = {
  nsg1 = {
    name     = "nsg-platform-connectivity"
    rg_key   = "rg2"
    nsg_rules = {
      rule1 = {
        name                       = "AllowHTTPS"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}
```

### Azure Firewall Configuration

| Variable | Type | Description | Required | Default | Example |
|----------|------|-------------|----------|---------|---------|
| `azure_firewall_name` | string | Azure Firewall name | ✅ | - | `"afw-platform-prod-01"` |

### Gateway Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `vnet_gws` | map(object) | VPN/ExpressRoute gateway config | Optional | See example below |

```hcl
vnet_gws = {
  gw1 = {
    gateway_name     = "vgw-platform-prod-01"
    rg_key          = "rg2"
    vnet_key        = "vnet1"
    gateway_type    = "Vpn"
    vpn_type        = "RouteBased"
    sku             = "VpnGw1"
    active_active   = false
  }
}
```

### ExpressRoute Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `expressroute_circuit_name` | string | ExpressRoute circuit name | Optional | `"er-platform-prod-01"` |

### Identity Services Configuration

#### Domain Controllers

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `dc_sa_name` | string | Storage account for domain controllers | Optional | `"saplatformdc001"` |
| `dc_kv_name` | string | Key Vault for domain controller secrets | Optional | `"kv-platform-dc-001"` |
| `dc_nics` | map(object) | Network interfaces for domain controllers | Optional | See example below |
| `dc_vms` | map(object) | Domain controller VM definitions | Optional | See example below |
| `admin_username` | string | Administrator username | Optional | `"azureadmin"` |
| `admin_password` | string | Administrator password | Optional | `"P@ssw0rd123!"` |

```hcl
dc_nics = {
  nic1 = {
    nic_name         = "nic-dc01"
    rg_key          = "rg3"
    subnet_key      = "snet3"
    private_ip      = "10.15.1.4"
  }
  nic2 = {
    nic_name         = "nic-dc02"
    rg_key          = "rg3"
    subnet_key      = "snet3"
    private_ip      = "10.15.1.5"
  }
}

dc_vms = {
  vm1 = {
    vm_name          = "vm-dc01"
    rg_key          = "rg3"
    nic_key         = "nic1"
    vm_size         = "Standard_D2s_v3"
    storage_account_type = "Premium_LRS"
    publisher       = "MicrosoftWindowsServer"
    offer          = "WindowsServer"
    sku            = "2019-Datacenter"
    version        = "latest"
  }
}
```

## 🚀 Deployment Instructions

### Prerequisites

1. Azure CLI installed and configured
2. Terraform >= 1.0 installed
3. Appropriate Azure permissions
4. Target subscription selected

### Step-by-Step Deployment

1. **Navigate to Platform Landing Zone**
   ```bash
   cd landing_zones/platform
   ```

2. **Update Configuration**
   Edit `terraform.tfvars` with your specific values:
   ```bash
   # Update subscription ID
   platform_subscription_id = "your-subscription-id"
   
   # Update resource names and locations
   # Update network addressing
   # Update feature flags
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

### Feature Toggles

Control optional components by setting these variables:

| Feature | Variable | Description |
|---------|----------|-------------|
| Domain Controllers | Set `dc_vms` | Deploy Windows domain controllers |
| VPN Gateway | Set `vnet_gws` | Deploy VPN gateway for site-to-site connectivity |
| ExpressRoute | Set `expressroute_circuit_name` | Deploy ExpressRoute circuit |
| Azure Firewall | Set `azure_firewall_name` | Deploy Azure Firewall (recommended) |

## 🔍 Post-Deployment Validation

### Verify Resources

```bash
# Check resource groups
az group list --output table

# Check virtual networks
az network vnet list --output table

# Check Azure Firewall
az network firewall list --output table

# Check domain controllers (if deployed)
az vm list --output table
```

### Network Connectivity Tests

```bash
# Test DNS resolution (if domain controllers deployed)
nslookup your-domain.com 10.15.1.4

# Test firewall rules
# Test gateway connectivity (if deployed)
```

## 🔧 Customization Examples

### Adding Additional Subnets

```hcl
platform_subnets = {
  # ...existing subnets...
  
  snet_new = {
    vnet_key                      = "vnet1"
    rg_key                        = "rg2"
    subnet_address_prefix         = ["10.0.10.0/24"]
    subnet_name                   = "snet-additional-workload"
    network_security_group_name   = "nsg-additional-workload"
    route_table_name             = "rt-additional-workload"
  }
}
```

### Custom NSG Rules

```hcl
platform_nsg = {
  nsg_custom = {
    name     = "nsg-custom-rules"
    rg_key   = "rg2"
    nsg_rules = {
      allow_rdp = {
        name                       = "AllowRDP"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
      }
      allow_ssh = {
        name                       = "AllowSSH"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.0.0/8"
        destination_address_prefix = "*"
      }
    }
  }
}
```

## 📊 Monitoring and Logging

The Platform Landing Zone includes:

- **Log Analytics Workspace**: Centralized logging for all resources
- **Automation Account**: For automated management tasks
- **Azure Monitor**: Resource monitoring and alerting
- **Network Watcher**: Network monitoring and diagnostics

### Key Metrics to Monitor

| Metric | Resource | Threshold |
|--------|----------|-----------|
| CPU Utilization | Domain Controllers | > 80% |
| Memory Usage | Domain Controllers | > 85% |
| Network Throughput | Azure Firewall | Monitor baseline |
| VPN Gateway Bandwidth | VPN Gateway | Monitor utilization |
| ExpressRoute Bandwidth | ExpressRoute | Monitor utilization |

## 🔒 Security Considerations

### Network Security

- NSGs are applied to all subnets with appropriate rules
- Azure Firewall provides centralized network filtering
- Private IP addresses are used for internal communication
- DNS servers are configured for domain-joined resources

### Access Control

- Service principals should be used for automation
- Just-in-time access should be enabled for VMs
- Network access should be restricted to necessary ports only
- Regular security assessments should be performed

## 🚨 Troubleshooting

### Common Issues

| Issue | Symptom | Solution |
|-------|---------|----------|
| Terraform state lock | Deployment hangs | Remove state lock: `terraform force-unlock <lock-id>` |
| IP address conflicts | Network creation fails | Verify address spaces don't overlap |
| Permission issues | Authorization errors | Verify service principal permissions |
| DNS resolution fails | Domain join issues | Check DNS server configuration |

### Debug Commands

```bash
# Check Terraform state
terraform state list

# Validate configuration
terraform validate

# Check specific resource
terraform state show <resource-name>

# Check Azure resource status
az resource show --ids <resource-id>
```

## 🔄 Maintenance

### Regular Tasks

- Update Terraform modules to latest versions
- Review and update NSG rules
- Monitor resource utilization
- Update domain controller patches
- Review firewall logs and rules

### Backup Strategy

- Terraform state files are stored in Azure Storage
- Domain controller data is backed up using Azure Backup
- Configuration files are version controlled in Git

## 📈 Scaling Considerations

### Horizontal Scaling

- Add additional domain controllers for redundancy
- Deploy additional Azure Firewall instances for high availability
- Implement multiple VPN gateways for increased throughput

### Vertical Scaling

- Upgrade domain controller VM sizes based on usage
- Increase Azure Firewall SKU for higher performance
- Upgrade VPN gateway SKU for increased bandwidth

## 🤝 Dependencies

This Platform Landing Zone has dependencies on:

- **Management Resources Landing Zone**: Must be deployed first for monitoring
- **Azure AD Tenant**: For identity integration
- **DNS Configuration**: For domain services

## 📋 Outputs

The Platform Landing Zone provides these outputs for use by other landing zones:

| Output | Description | Usage |
|--------|-------------|-------|
| `vnet_ids` | Virtual network resource IDs | For VNet peering |
| `subnet_ids` | Subnet resource IDs | For resource deployment |
| `firewall_private_ip` | Azure Firewall private IP | For route tables |
| `dns_servers` | Domain controller IPs | For DNS configuration |
| `resource_group_ids` | Resource group IDs | For resource deployment |
