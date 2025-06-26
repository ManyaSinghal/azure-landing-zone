# Azure Network Module

This comprehensive module collection provides Terraform modules for creating and managing various Azure networking resources including Virtual Networks, Subnets, Network Security Groups, Application Gateways, VPN Gateways, and more.

## Overview

The Azure Network module collection offers a complete set of networking components to build secure, scalable, and well-architected network infrastructure in Azure. Each sub-module is designed to work independently or together to create complex network topologies.

## Module Structure

```
AzureNetwork/
├── virtual_network/           # Virtual Network creation and management
├── subnet/                    # Subnet configuration
├── network_security_group/    # NSG rules and associations
├── route_table/              # Custom routing tables
├── public_ip/                # Public IP addresses
├── network_interface/        # Network interfaces for VMs
├── application_gateway/      # Application Gateway (Layer 7 load balancer)
├── vpn_gateway/             # VPN Gateway for site-to-site connectivity
├── express_route/           # ExpressRoute connectivity
├── AzureFirewall/           # Azure Firewall configuration
├── PrivateEndpoint/         # Private endpoint connectivity
└── virtual_network_peering/ # VNet peering configurations
```

## Quick Start

### Basic Virtual Network Setup

```hcl
# Create Resource Group
module "resource_group" {
  source = "../ResourceGroup"
  
  resource_group_name = "rg-network-prod-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Production"
    Project     = "NetworkInfrastructure"
    Owner       = "Network Team"
  }
}

# Create Virtual Network
module "virtual_network" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = module.resource_group.az_resource_group_name
  location            = module.resource_group.az_resource_group_location
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["168.63.129.16"] # Azure DNS
  vnet_tags          = module.resource_group.az_resource_group_tags
}

# Create Subnets
module "subnet_web" {
  source = "./AzureNetwork/subnet"
  
  subnet_name          = "subnet-web"
  resource_group_name  = module.resource_group.az_resource_group_name
  virtual_network_name = module.virtual_network.vnet_name
  subnet_address_prefix = "10.0.1.0/24"
}

module "subnet_app" {
  source = "./AzureNetwork/subnet"
  
  subnet_name          = "subnet-app"
  resource_group_name  = module.resource_group.az_resource_group_name
  virtual_network_name = module.virtual_network.vnet_name
  subnet_address_prefix = "10.0.2.0/24"
}

module "subnet_data" {
  source = "./AzureNetwork/subnet"
  
  subnet_name          = "subnet-data"
  resource_group_name  = module.resource_group.az_resource_group_name
  virtual_network_name = module.virtual_network.vnet_name
  subnet_address_prefix = "10.0.3.0/24"
}
```

## Sub-Modules Documentation

### Core Networking Modules

| Module | Purpose | Key Features |
|--------|---------|--------------|
| [virtual_network](./virtual_network/) | Core VNet infrastructure | Address spaces, DNS, DDoS protection |
| [subnet](./subnet/) | Network segmentation | Address prefixes, service endpoints |
| [network_security_group](./network_security_group/) | Security rules | Traffic filtering, port restrictions |
| [route_table](./route_table/) | Custom routing | Next hop configuration, user-defined routes |
| [public_ip](./public_ip/) | External connectivity | Static/dynamic allocation, zones |
| [network_interface](./network_interface/) | VM connectivity | IP configurations, NSG associations |

### Advanced Networking Modules

| Module | Purpose | Key Features |
|--------|---------|--------------|
| [application_gateway](./application_gateway/) | Layer 7 load balancing | SSL termination, WAF, path-based routing |
| [vpn_gateway](./vpn_gateway/) | Site-to-site connectivity | Point-to-site, site-to-site, ExpressRoute |
| [express_route](./express_route/) | Private connectivity | Dedicated connections, high bandwidth |
| [AzureFirewall](./AzureFirewall/) | Network security | Application/network rules, threat intelligence |
| [PrivateEndpoint](./PrivateEndpoint/) | Private service access | Secure PaaS connectivity |
| [virtual_network_peering](./virtual_network_peering/) | VNet interconnection | Global peering, gateway transit |

## Architecture Patterns

### Hub-and-Spoke Network Topology

```hcl
# Hub Virtual Network
module "hub_vnet" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-hub-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
  
  vnet_tags = {
    NetworkType = "Hub"
    Environment = "Production"
  }
}

# Spoke Virtual Networks
module "spoke_prod_vnet" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-prod-eastus2"
  resource_group_name  = "rg-workload-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.1.0.0/16"]
  
  vnet_tags = {
    NetworkType = "Spoke"
    Environment = "Production"
    Workload    = "WebApplication"
  }
}

module "spoke_dev_vnet" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-spoke-dev-eastus2"
  resource_group_name  = "rg-workload-dev"
  location            = "East US 2"
  vnet_address_space  = ["10.2.0.0/16"]
  
  vnet_tags = {
    NetworkType = "Spoke"
    Environment = "Development"
    Workload    = "WebApplication"
  }
}

# VNet Peering
module "hub_to_spoke_prod_peering" {
  source = "./AzureNetwork/virtual_network_peering"
  
  peering_name_1_to_2         = "hub-to-spoke-prod"
  peering_name_2_to_1         = "spoke-prod-to-hub"
  vnet_1_name                 = module.hub_vnet.vnet_name
  vnet_1_resource_group       = "rg-network-hub-prod"
  vnet_2_name                 = module.spoke_prod_vnet.vnet_name
  vnet_2_resource_group       = "rg-workload-prod"
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
  use_remote_gateways        = false
}
```

### DMZ Network with Application Gateway

```hcl
# DMZ Virtual Network
module "dmz_vnet" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-dmz-prod-eastus2"
  resource_group_name  = "rg-dmz-prod"
  location            = "East US 2"
  vnet_address_space  = ["10.100.0.0/24"]
  
  vnet_tags = {
    NetworkType = "DMZ"
    Environment = "Production"
  }
}

# Application Gateway Subnet
module "subnet_appgw" {
  source = "./AzureNetwork/subnet"
  
  subnet_name          = "subnet-appgw"
  resource_group_name  = "rg-dmz-prod"
  virtual_network_name = module.dmz_vnet.vnet_name
  subnet_address_prefix = "10.100.0.0/28"
}

# Application Gateway Public IP
module "appgw_public_ip" {
  source = "./AzureNetwork/public_ip"
  
  public_ip_name      = "pip-appgw-prod"
  resource_group_name = "rg-dmz-prod"
  location           = "East US 2"
  allocation_method  = "Static"
  sku               = "Standard"
}

# Application Gateway
module "application_gateway" {
  source = "./AzureNetwork/application_gateway"
  
  app_gateway_name    = "appgw-prod-eastus2"
  resource_group_name = "rg-dmz-prod"
  location           = "East US 2"
  subnet_id          = module.subnet_appgw.subnet_id
  public_ip_id       = module.appgw_public_ip.public_ip_id
  
  # Additional configuration...
}
```

## Network Security Best Practices

### 1. Network Segmentation

```hcl
# Web Tier NSG
module "nsg_web" {
  source = "./AzureNetwork/network_security_group"
  
  nsg_name            = "nsg-web-prod"
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
      name                       = "AllowHTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  ]
}

# Application Tier NSG
module "nsg_app" {
  source = "./AzureNetwork/network_security_group"
  
  nsg_name            = "nsg-app-prod"
  resource_group_name = "rg-network-prod"
  location           = "East US 2"
  
  security_rules = [
    {
      name                       = "AllowWebTier"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.0.1.0/24"  # Web tier subnet
      destination_address_prefix = "*"
    }
  ]
}

# Data Tier NSG
module "nsg_data" {
  source = "./AzureNetwork/network_security_group"
  
  nsg_name            = "nsg-data-prod"
  resource_group_name = "rg-network-prod"
  location           = "East US 2"
  
  security_rules = [
    {
      name                       = "AllowAppTier"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "10.0.2.0/24"  # App tier subnet
      destination_address_prefix = "*"
    }
  ]
}
```

### 2. Route Tables for Traffic Control

```hcl
# Route Table for Spoke Networks
module "route_table_spoke" {
  source = "./AzureNetwork/route_table"
  
  route_table_name    = "rt-spoke-prod"
  resource_group_name = "rg-network-prod"
  location           = "East US 2"
  
  routes = [
    {
      name                   = "default-to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type         = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.0.4"  # Azure Firewall IP
    },
    {
      name           = "local-vnet"
      address_prefix = "10.1.0.0/16"
      next_hop_type  = "VnetLocal"
    }
  ]
}
```

## IP Address Planning

### Recommended Address Space Allocation

| Network Type | Address Space | Purpose | Capacity |
|-------------|---------------|---------|----------|
| Hub Network | `10.0.0.0/16` | Shared services, firewall, gateways | 65,536 IPs |
| Production Spoke | `10.1.0.0/16` | Production workloads | 65,536 IPs |
| Development Spoke | `10.2.0.0/16` | Development workloads | 65,536 IPs |
| Testing Spoke | `10.3.0.0/16` | Testing workloads | 65,536 IPs |
| DMZ Network | `10.100.0.0/24` | Internet-facing resources | 256 IPs |

### Subnet Planning Example

```hcl
# Hub Network Subnets
locals {
  hub_subnets = {
    "GatewaySubnet"          = "10.0.0.0/27"    # VPN/ER Gateway (required name)
    "AzureFirewallSubnet"    = "10.0.0.32/26"   # Azure Firewall (required name)
    "subnet-management"      = "10.0.1.0/24"    # Management VMs
    "subnet-shared-services" = "10.0.2.0/24"    # Domain controllers, DNS
  }
  
  spoke_prod_subnets = {
    "subnet-web"  = "10.1.1.0/24"   # Web tier
    "subnet-app"  = "10.1.2.0/24"   # Application tier
    "subnet-data" = "10.1.3.0/24"   # Database tier
  }
}
```

## High Availability and Disaster Recovery

### Multi-Region Network Setup

```hcl
# Primary Region Hub
module "hub_primary" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-eastus2"
  resource_group_name  = "rg-network-hub-primary"
  location            = "East US 2"
  vnet_address_space  = ["10.0.0.0/16"]
}

# Secondary Region Hub
module "hub_secondary" {
  source = "./AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-hub-prod-westus2"
  resource_group_name  = "rg-network-hub-secondary"
  location            = "West US 2"
  vnet_address_space  = ["10.10.0.0/16"]
}

# Global VNet Peering
module "global_peering" {
  source = "./AzureNetwork/virtual_network_peering"
  
  peering_name_1_to_2         = "primary-to-secondary"
  peering_name_2_to_1         = "secondary-to-primary"
  vnet_1_name                 = module.hub_primary.vnet_name
  vnet_1_resource_group       = "rg-network-hub-primary"
  vnet_2_name                 = module.hub_secondary.vnet_name
  vnet_2_resource_group       = "rg-network-hub-secondary"
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
}
```

## Monitoring and Troubleshooting

### Network Monitoring Setup

```hcl
# Network Watcher (automatically created per region)
# Enable Flow Logs for NSGs
resource "azurerm_network_watcher_flow_log" "nsg_flow_logs" {
  network_watcher_name = "NetworkWatcher_eastus2"
  resource_group_name  = "NetworkWatcherRG"
  
  network_security_group_id = module.nsg_web.nsg_id
  storage_account_id       = module.storage_logs.storage_account_id
  enabled                  = true
  
  retention_policy {
    enabled = true
    days    = 30
  }
  
  traffic_analytics {
    enabled               = true
    workspace_id         = module.log_analytics.workspace_id
    workspace_region     = "East US 2"
    workspace_resource_id = module.log_analytics.workspace_resource_id
    interval_in_minutes   = 10
  }
}
```

### Common Troubleshooting Commands

```bash
# Test network connectivity
az network watcher test-connectivity \
  --source-resource "/subscriptions/.../resourceGroups/rg-vm/providers/Microsoft.Compute/virtualMachines/vm-web" \
  --dest-resource "/subscriptions/.../resourceGroups/rg-vm/providers/Microsoft.Compute/virtualMachines/vm-app" \
  --dest-port 8080

# Check effective NSG rules
az network nic list-effective-nsg \
  --name "nic-vm-web" \
  --resource-group "rg-network-prod"

# Verify route table
az network nic show-effective-route-table \
  --name "nic-vm-web" \
  --resource-group "rg-network-prod"

# Check VNet peering status
az network vnet peering list \
  --resource-group "rg-network-hub" \
  --vnet-name "vnet-hub-prod-eastus2"
```

## Cost Optimization

### Network Cost Considerations

| Resource | Cost Factors | Optimization Tips |
|----------|--------------|-------------------|
| VNet Peering | Data transfer charges | Use hub-spoke instead of mesh topology |
| VPN Gateway | Gateway SKU, bandwidth | Right-size based on requirements |
| Application Gateway | Capacity units, data processing | Use autoscaling appropriately |
| Public IP | Static vs dynamic allocation | Use dynamic for dev/test environments |
| NAT Gateway | Data processing charges | Consider for multiple VMs needing outbound |

### Cost Optimization Example

```hcl
# Use Basic SKU for development environments
module "vpn_gateway_dev" {
  source = "./AzureNetwork/vpn_gateway"
  
  gateway_name        = "vpngw-dev-eastus2"
  resource_group_name = "rg-network-dev"
  location           = "East US 2"
  gateway_type       = "Vpn"
  sku               = "Basic"          # Lower cost for dev
  generation        = "Generation1"
  
  # Enable auto-shutdown for cost savings
  tags = {
    Environment  = "Development"
    AutoShutdown = "Enabled"
  }
}

# Use Standard SKU for production
module "vpn_gateway_prod" {
  source = "./AzureNetwork/vpn_gateway"
  
  gateway_name        = "vpngw-prod-eastus2"
  resource_group_name = "rg-network-prod"
  location           = "East US 2"
  gateway_type       = "Vpn"
  sku               = "VpnGw1"         # Higher performance for prod
  generation        = "Generation2"
  
  tags = {
    Environment = "Production"
    Backup     = "Required"
  }
}
```

## Security Best Practices

### 1. Network Security Groups (NSGs)
- Implement least privilege access
- Use application security groups for dynamic grouping
- Enable NSG flow logs for monitoring

### 2. Azure Firewall
- Use FQDN filtering for outbound traffic
- Implement network and application rules
- Enable threat intelligence

### 3. Private Endpoints
- Use for all PaaS services when possible
- Implement DNS forwarding for resolution
- Monitor private endpoint connectivity

### 4. DDoS Protection
- Enable DDoS Protection Standard for production
- Configure DDoS response team contacts
- Set up monitoring and alerting

## Migration and Integration

### Migrating from On-Premises

```hcl
# ExpressRoute for hybrid connectivity
module "express_route" {
  source = "./AzureNetwork/express_route"
  
  circuit_name        = "er-onprem-to-azure"
  resource_group_name = "rg-network-hybrid"
  location           = "East US 2"
  service_provider    = "Equinix"
  peering_location   = "Washington DC"
  bandwidth_in_mbps  = 1000
  
  tags = {
    Purpose = "HybridConnectivity"
    SLA     = "99.95%"
  }
}

# VPN as backup connectivity
module "vpn_gateway_backup" {
  source = "./AzureNetwork/vpn_gateway"
  
  gateway_name        = "vpngw-backup-eastus2"
  resource_group_name = "rg-network-hybrid"
  location           = "East US 2"
  gateway_type       = "Vpn"
  sku               = "VpnGw1"
  
  # Configure as backup to ExpressRoute
  active_active = true
  
  tags = {
    Purpose = "BackupConnectivity"
    Primary = "ExpressRoute"
  }
}
```

## Contributing

When contributing to network modules:

1. **Follow naming conventions:** Use consistent naming patterns
2. **Document thoroughly:** Include examples and use cases
3. **Test connectivity:** Verify all network paths work as expected
4. **Security review:** Ensure proper security controls
5. **Cost consideration:** Document cost implications

## Support

For network-related issues:
- Check individual module documentation
- Review Azure networking best practices
- Use Azure Network Watcher for troubleshooting
- Contact the Network Engineering team

---

**Module Collection Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0
