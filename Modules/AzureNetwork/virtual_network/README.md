# Azure Virtual Network Module

This Terraform module creates and manages Azure Virtual Networks (VNets) with support for custom DNS servers, DDoS protection, and comprehensive tagging.

## Overview

Azure Virtual Networks (VNets) are the fundamental building block for private networks in Azure. This module provides a standardized way to create VNets with proper configuration for address spaces, DNS servers, DDoS protection, and tagging strategies.

## Features

- ✅ Azure Virtual Network creation
- ✅ Custom address space configuration
- ✅ DNS server configuration
- ✅ DDoS Protection Plan integration
- ✅ Comprehensive tagging support
- ✅ Multiple output values for integration
- ✅ Support for multiple address spaces

## Usage

### Basic Usage

```hcl
module "virtual_network" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["168.63.129.16"]  # Azure DNS
  
  vnet_tags = {
    Environment = "Production"
    NetworkType = "Hub"
    Project     = "NetworkInfrastructure"
    Owner       = "Network Team"
  }
}
```

### Advanced Usage with DDoS Protection

```hcl
# DDoS Protection Plan (optional)
resource "azurerm_network_ddos_protection_plan" "ddos_plan" {
  name                = "ddos-protection-plan-prod"
  location            = "East US 2"
  resource_group_name = "rg-network-security"
  
  tags = {
    Environment = "Production"
    Purpose     = "DDoSProtection"
  }
}

# Virtual Network with DDoS Protection
module "virtual_network_protected" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]  # Custom DNS servers
  
  # Enable DDoS Protection
  ddos_protection_plan = {
    ddos_plan = {
      id     = azurerm_network_ddos_protection_plan.ddos_plan.id
      enable = true
    }
  }
  
  vnet_tags = {
    Environment    = "Production"
    NetworkType    = "Hub"
    Project        = "NetworkInfrastructure"
    Owner          = "Network Team"
    DDoSProtection = "Enabled"
  }
}
```

### Hub-and-Spoke Architecture

```hcl
# Hub Virtual Network
module "hub_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-hub"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]  # Domain controllers
  
  vnet_tags = {
    Environment = "Production"
    NetworkType = "Hub"
    Purpose     = "SharedServices"
  }
}

# Spoke Virtual Network - Production
module "spoke_prod_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-prod-eastus2"
  resource_group_name  = "rg-workload-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]  # Hub DNS servers
  
  vnet_tags = {
    Environment = "Production"
    NetworkType = "Spoke"
    Workload    = "WebApplication"
  }
}

# Spoke Virtual Network - Development
module "spoke_dev_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-dev-eastus2"
  resource_group_name  = "rg-workload-dev"
  location            = "East US 2"
  vnet_address_space  = ["10.2.0.0/16"]
  dns_servers         = ["168.63.129.16"]  # Azure DNS for dev
  
  vnet_tags = {
    Environment = "Development"
    NetworkType = "Spoke"
    Workload    = "WebApplication"
  }
}
```

### Multi-Address Space Virtual Network

```hcl
module "multi_space_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-multi-prod-eastus2"
  resource_group_name  = "rg-network-prod"
  location            = "East US 2"
  
  # Multiple address spaces
  vnet_address_space = [
    "10.0.0.0/16",    # Primary address space
    "172.16.0.0/16"   # Secondary address space
  ]
  
  dns_servers = ["10.0.0.4", "10.0.0.5"]
  
  vnet_tags = {
    Environment    = "Production"
    AddressSpaces  = "Multiple"
    Purpose        = "LargeWorkload"
  }
}
```

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
| [azurerm_virtual_network.az_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|----------|---------|
| virtual_network_name | Name of the Azure Virtual Network | `string` | `""` | ✅ | `"vnet-hub-prod-eastus2"` |
| resource_group_name | Name of the Resource Group where VNet will be created | `string` | `"rg-demo-westeurope-01"` | ✅ | `"rg-network-prod"` |
| location | Azure region for the Virtual Network | `string` | `"westeurope"` | ✅ | `"East US 2"` |
| vnet_address_space | List of address spaces for the Virtual Network | `list(string)` | `["10.0.0.0/16"]` | ✅ | `["10.0.0.0/16", "172.16.0.0/16"]` |
| dns_servers | List of DNS servers for the Virtual Network | `any` | `null` | ❌ | `["10.0.0.4", "10.0.0.5"]` |
| vnet_tags | Tags to assign to the Virtual Network | `map(string)` | `{}` | ❌ | `{"Environment": "Production"}` |
| ddos_protection_plan | DDoS Protection Plan configuration | `map(string)` | `{}` | ❌ | See DDoS section below |

### DDoS Protection Plan Configuration

```hcl
ddos_protection_plan = {
  "ddos_plan" = {
    id     = "/subscriptions/.../providers/Microsoft.Network/ddosProtectionPlans/ddos-plan"
    enable = true
  }
}
```

## Outputs

| Name | Description | Type |
|------|-------------|------|
| az_virtual_network_id | The ID of the Virtual Network | `string` |
| az_virtual_network_name | The name of the Virtual Network | `string` |
| az_virtual_network_address_space | List of address spaces used by the Virtual Network | `list(string)` |
| az_vnet_dnsservers | List of DNS servers configured for the Virtual Network | `list(string)` |

## Address Space Planning

### Recommended Address Space Allocation

| Network Type | Address Space | Capacity | Use Case |
|-------------|---------------|----------|----------|
| Hub Network | `10.0.0.0/16` | 65,536 IPs | Shared services, gateways, firewall |
| Production Spoke | `10.1.0.0/16` | 65,536 IPs | Production workloads |
| Development Spoke | `10.2.0.0/16` | 65,536 IPs | Development workloads |
| Testing Spoke | `10.3.0.0/16` | 65,536 IPs | Testing workloads |
| DMZ Network | `10.100.0.0/24` | 256 IPs | Internet-facing resources |

### Azure Reserved Address Ranges

Azure reserves certain IP addresses in each subnet:
- **x.x.x.0**: Network address
- **x.x.x.1**: Reserved by Azure for the default gateway
- **x.x.x.2, x.x.x.3**: Reserved by Azure to map Azure DNS IPs to the VNet space
- **x.x.x.255**: Network broadcast address

### Address Space Best Practices

1. **Plan for Growth**: Allocate larger address spaces than initially needed
2. **Avoid Overlaps**: Ensure no overlap with on-premises networks
3. **Regional Consistency**: Use consistent addressing across regions
4. **Segmentation**: Plan subnet boundaries in advance

```hcl
# Example: Well-planned address spaces
locals {
  address_spaces = {
    # Hub networks
    hub_primary   = "10.0.0.0/16"   # Primary region hub
    hub_secondary = "10.10.0.0/16"  # Secondary region hub
    
    # Production spokes
    prod_web      = "10.1.0.0/16"   # Web applications
    prod_data     = "10.2.0.0/16"   # Data services
    prod_api      = "10.3.0.0/16"   # API services
    
    # Non-production spokes
    dev_workloads = "10.100.0.0/16" # Development
    test_workloads = "10.101.0.0/16" # Testing
    
    # Special purposes
    dmz_network   = "172.16.0.0/24"  # DMZ
    management    = "172.16.1.0/24"  # Management
  }
}
```

## DNS Configuration

### DNS Server Options

| DNS Type | Configuration | Use Case |
|----------|---------------|----------|
| Azure DNS | `["168.63.129.16"]` | Default Azure name resolution |
| Custom DNS | `["10.0.0.4", "10.0.0.5"]` | On-premises DNS integration |
| Hybrid DNS | `["10.0.0.4", "168.63.129.16"]` | Primary custom, fallback Azure |

### DNS Best Practices

```hcl
# Hub network with custom DNS
module "hub_vnet_dns" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-hub"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  
  # Custom DNS servers (domain controllers)
  dns_servers = [
    "10.0.0.4",   # Primary domain controller
    "10.0.0.5"    # Secondary domain controller
  ]
  
  vnet_tags = {
    Environment = "Production"
    DNSType     = "CustomDomainControllers"
  }
}

# Spoke network inheriting hub DNS
module "spoke_vnet_inherited_dns" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-prod-eastus2"
  resource_group_name  = "rg-workload-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.1.0.0/16"]
  
  # Inherit DNS from hub (via peering)
  dns_servers = [
    "10.0.0.4",   # Hub primary DNS
    "10.0.0.5"    # Hub secondary DNS
  ]
  
  vnet_tags = {
    Environment = "Production"
    DNSType     = "InheritedFromHub"
  }
}
```

## Integration Examples

### Integration with Subnet Module

```hcl
module "virtual_network" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-app-prod-eastus2"
  resource_group_name  = "rg-network-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  
  vnet_tags = {
    Environment = "Production"
    Purpose     = "ApplicationTier"
  }
}

# Create subnets within the VNet
module "subnet_web" {
  source = "../subnet"
  
  subnet_name          = "subnet-web"
  resource_group_name  = module.virtual_network.resource_group_name
  virtual_network_name = module.virtual_network.az_virtual_network_name
  subnet_address_prefix = "10.1.1.0/24"
}

module "subnet_app" {
  source = "../subnet"
  
  subnet_name          = "subnet-app"
  resource_group_name  = module.virtual_network.resource_group_name
  virtual_network_name = module.virtual_network.az_virtual_network_name
  subnet_address_prefix = "10.1.2.0/24"
}

module "subnet_data" {
  source = "../subnet"
  
  subnet_name          = "subnet-data"
  resource_group_name  = module.virtual_network.resource_group_name
  virtual_network_name = module.virtual_network.az_virtual_network_name
  subnet_address_prefix = "10.1.3.0/24"
}
```

### Integration with VNet Peering

```hcl
# Hub Virtual Network
module "hub_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-hub"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

# Spoke Virtual Network
module "spoke_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-prod-eastus2"
  resource_group_name  = "rg-workload-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

# VNet Peering
module "vnet_peering" {
  source = "../virtual_network_peering"
  
  peering_name_1_to_2         = "hub-to-spoke"
  peering_name_2_to_1         = "spoke-to-hub"
  vnet_1_name                 = module.hub_vnet.az_virtual_network_name
  vnet_1_resource_group       = "rg-network-hub"
  vnet_2_name                 = module.spoke_vnet.az_virtual_network_name
  vnet_2_resource_group       = "rg-workload-prod"
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
  use_remote_gateways        = false
}
```

## Security Considerations

### 1. Network Segmentation

- Use separate VNets for different environments (prod/dev/test)
- Implement proper subnet segmentation within VNets
- Use Network Security Groups for traffic filtering

### 2. DNS Security

```hcl
# Secure DNS configuration
module "secure_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-secure-prod-eastus2"
  resource_group_name  = "rg-network-secure"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  
  # Use private DNS servers for security
  dns_servers = [
    "10.0.0.4",   # Primary private DNS
    "10.0.0.5"    # Secondary private DNS
  ]
  
  vnet_tags = {
    Environment = "Production"
    Security    = "High"
    Compliance  = "Required"
  }
}
```

### 3. DDoS Protection

```hcl
# Enable DDoS Protection for production VNets
resource "azurerm_network_ddos_protection_plan" "production_ddos" {
  name                = "ddos-protection-prod"
  location            = "East US 2"
  resource_group_name = "rg-network-security"
}

module "protected_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-protected-prod-eastus2"
  resource_group_name  = "rg-network-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  
  ddos_protection_plan = {
    production = {
      id     = azurerm_network_ddos_protection_plan.production_ddos.id
      enable = true
    }
  }
  
  vnet_tags = {
    Environment    = "Production"
    DDoSProtection = "Standard"
  }
}
```

## Monitoring and Diagnostics

### Network Monitoring Setup

```hcl
# Enable diagnostic settings for VNet
resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostics" {
  name                       = "vnet-diagnostics"
  target_resource_id         = module.virtual_network.az_virtual_network_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  enabled_log {
    category = "VMProtectionAlerts"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
    
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
```

### Validation Commands

```bash
# Check VNet configuration
az network vnet show \
  --resource-group "rg-network-prod" \
  --name "vnet-hub-prod-eastus2"

# List VNet address spaces
az network vnet show \
  --resource-group "rg-network-prod" \
  --name "vnet-hub-prod-eastus2" \
  --query "addressSpace.addressPrefixes"

# Check DNS servers
az network vnet show \
  --resource-group "rg-network-prod" \
  --name "vnet-hub-prod-eastus2" \
  --query "dnsServers"

# List subnets in VNet
az network vnet subnet list \
  --resource-group "rg-network-prod" \
  --vnet-name "vnet-hub-prod-eastus2" \
  --output table
```

## Troubleshooting

### Common Issues

#### 1. Address Space Conflicts

```bash
Error: The address space '10.0.0.0/16' overlaps with existing address space
```

**Solution:** Ensure address spaces don't overlap with existing VNets or on-premises networks.

#### 2. Invalid DNS Server Configuration

```bash
Error: The DNS server '10.0.0.300' is not a valid IP address
```

**Solution:** Use valid IP addresses for DNS servers.

#### 3. DDoS Protection Plan Issues

```bash
Error: DDoS Protection Plan not found
```

**Solution:** Ensure the DDoS Protection Plan exists and is in the same region.

### Diagnostic Commands

```bash
# Test DNS resolution
nslookup azure.microsoft.com 10.0.0.4

# Check connectivity between VNets
az network watcher test-connectivity \
  --source-resource "/subscriptions/.../resourceGroups/rg-vm1/providers/Microsoft.Compute/virtualMachines/vm1" \
  --dest-resource "/subscriptions/.../resourceGroups/rg-vm2/providers/Microsoft.Compute/virtualMachines/vm2"

# Verify effective routes
az network nic show-effective-route-table \
  --resource-group "rg-vm" \
  --name "nic-vm1"
```

## Cost Optimization

### VNet Cost Considerations

| Component | Cost Factor | Optimization |
|-----------|-------------|--------------|
| VNet | No direct cost | Consolidate when possible |
| VNet Peering | Data transfer charges | Use hub-spoke topology |
| DDoS Protection | Monthly fee per plan | Share across multiple VNets |
| DNS Queries | No additional cost | Use Azure DNS when possible |

### Cost-Effective Configuration

```hcl
# Development environment - cost optimized
module "dev_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-dev-eastus2"
  resource_group_name  = "rg-network-dev"
  location            = "East US 2"
  vnet_address_space  = ["10.100.0.0/16"]
  
  # Use Azure DNS to avoid custom DNS costs
  dns_servers = ["168.63.129.16"]
  
  # No DDoS protection for dev environment
  ddos_protection_plan = {}
  
  vnet_tags = {
    Environment = "Development"
    CostCenter  = "Development"
    AutoShutdown = "Enabled"
  }
}
```

## Migration Considerations

### Migrating from Other Cloud Providers

```hcl
# VNet for migrated workloads
module "migration_vnet" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-migration-prod-eastus2"
  resource_group_name  = "rg-migration"
  location            = "East US 2"
  
  # Use address space that doesn't conflict with source environment
  vnet_address_space = ["172.16.0.0/16"]
  
  # Hybrid DNS during migration
  dns_servers = [
    "172.16.0.4",      # Azure-based DNS
    "192.168.1.10"     # On-premises DNS during migration
  ]
  
  vnet_tags = {
    Environment = "Production"
    Migration   = "InProgress"
    Source      = "AWS"
  }
}
```

## Best Practices Summary

### 1. Planning
- ✅ Plan address spaces carefully to avoid conflicts
- ✅ Consider future growth and expansion
- ✅ Document network architecture and addressing

### 2. Security
- ✅ Use Network Security Groups for traffic filtering
- ✅ Implement DDoS protection for production workloads
- ✅ Use private DNS when possible

### 3. Performance
- ✅ Place resources in the same region when possible
- ✅ Use VNet peering instead of VPN for Azure-to-Azure connectivity
- ✅ Consider ExpressRoute for high-bandwidth requirements

### 4. Cost Management
- ✅ Share DDoS Protection Plans across multiple VNets
- ✅ Use Azure DNS when custom DNS is not required
- ✅ Implement proper resource tagging for cost tracking

### 5. Monitoring
- ✅ Enable diagnostic settings for all production VNets
- ✅ Monitor VNet metrics and alerts
- ✅ Use Network Watcher for troubleshooting

## Example Implementation

See the [Example](./Example/) directory for a complete implementation example with:
- Basic VNet configuration
- Advanced configuration with DDoS protection
- Hub-and-spoke topology example
- Integration with other network modules

---

**Module Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0
