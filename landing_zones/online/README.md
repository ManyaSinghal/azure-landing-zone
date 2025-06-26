# Online Landing Zone

The Online Landing Zone is designed for hosting internet-facing applications and services that require public connectivity while maintaining security and compliance standards.

## 🏗️ Architecture Overview

The Online Landing Zone implements a spoke component in the hub-and-spoke architecture, providing:
- Public-facing application hosting
- Internet connectivity with security controls
- Integration with platform hub for shared services
- DMZ-style network segmentation
- Web application firewall and DDoS protection

## 📋 Resources Deployed

| Resource Type | Count | Purpose |
|---------------|-------|---------|
| Resource Groups | 1-3 | Logical grouping of online resources |
| Virtual Networks | 1+ | Online workload networking |
| Subnets | Multiple | DMZ and application segmentation |
| Network Security Groups | Multiple | Network access control |
| VNet Peering | 1+ | Connectivity to hub |
| Route Tables | Multiple | Traffic routing through hub |
| Application Gateway | 1+ | Web application firewall and load balancing |
| Public IPs | Multiple | Internet-facing endpoints |

## 🔧 Configuration Variables

### terraform.tfvars Structure

The Online Landing Zone uses the following configuration structure in `terraform.tfvars`:

### Resource Groups Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `resource_groups` | map(object) | Resource group definitions | ✅ | See example below |

#### Example Resource Groups Configuration

```hcl
resource_groups = {
  online_rg1 = {
    resource_group_name = "rg-online-prod-web"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Online"
      Exposure    = "Internet"
      CostCenter  = "Marketing"
      Owner       = "WebTeam"
    }
  }
  online_rg2 = {
    resource_group_name = "rg-online-prod-app"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Online"
      Tier        = "Application"
      CostCenter  = "Marketing"
    }
  }
  online_rg3 = {
    resource_group_name = "rg-online-prod-data"
    location            = "East US"
    rg_tags = {
      Environment = "Production"
      Workload    = "Online"
      DataClass   = "Public"
      CostCenter  = "Marketing"
    }
  }
}
```

### Networking Configuration

#### Virtual Networks

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `online_virtual_networks` | map(object) | VNet definitions for online workloads | ✅ | See example below |

```hcl
online_virtual_networks = {
  online_vnet1 = {
    virtual_network_name = "vnet-online-prod-01"
    rg_key               = "online_rg1"
    vnet_address_space   = ["10.3.0.0/16"]
    dns_servers          = ["10.15.1.4", "10.15.1.5"]  # Platform domain controllers
  }
  online_vnet2 = {
    virtual_network_name = "vnet-online-dmz-01"
    rg_key               = "online_rg1"
    vnet_address_space   = ["10.4.0.0/16"]
    dns_servers          = ["168.63.129.16"]  # Azure DNS for internet-facing
  }
}
```

#### Subnets

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `online_subnets` | map(object) | Subnet definitions for online workloads | ✅ | See example below |

```hcl
online_subnets = {
  online_dmz_subnet = {
    vnet_key                    = "online_vnet2"
    rg_key                      = "online_rg1"
    subnet_name                 = "snet-online-dmz"
    subnet_address_prefix       = ["10.4.1.0/24"]
    network_security_group_name = "nsg-online-dmz"
    route_table_name           = "rt-online-dmz"
    service_endpoints          = ["Microsoft.Storage", "Microsoft.KeyVault"]
  }
  online_web_subnet = {
    vnet_key                    = "online_vnet1"
    rg_key                      = "online_rg1"
    subnet_name                 = "snet-online-web"
    subnet_address_prefix       = ["10.3.1.0/24"]
    network_security_group_name = "nsg-online-web"
    route_table_name           = "rt-online-web"
    service_endpoints          = ["Microsoft.Storage", "Microsoft.KeyVault"]
  }
  online_app_subnet = {
    vnet_key                    = "online_vnet1"
    rg_key                      = "online_rg2"
    subnet_name                 = "snet-online-app"
    subnet_address_prefix       = ["10.3.2.0/24"]
    network_security_group_name = "nsg-online-app"
    route_table_name           = "rt-online-app"
    service_endpoints          = ["Microsoft.Sql", "Microsoft.Storage"]
  }
  online_data_subnet = {
    vnet_key                    = "online_vnet1"
    rg_key                      = "online_rg3"
    subnet_name                 = "snet-online-data"
    subnet_address_prefix       = ["10.3.3.0/24"]
    network_security_group_name = "nsg-online-data"
    route_table_name           = "rt-online-data"
    service_endpoints          = ["Microsoft.Sql"]
  }
  app_gateway_subnet = {
    vnet_key                    = "online_vnet2"
    rg_key                      = "online_rg1"
    subnet_name                 = "snet-app-gateway"
    subnet_address_prefix       = ["10.4.2.0/24"]
    network_security_group_name = "nsg-app-gateway"
    route_table_name           = ""
    service_endpoints          = []
  }
}
```

#### Network Security Groups

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `online_nsg` | map(object) | NSG definitions with security rules | ✅ | See example below |

```hcl
online_nsg = {
  nsg_online_dmz = {
    name     = "nsg-online-dmz"
    rg_key   = "online_rg1"
    nsg_rules = {
      allow_https_internet = {
        name                       = "AllowHTTPSFromInternet"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
      allow_http_internet = {
        name                       = "AllowHTTPFromInternet"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
      allow_app_gateway_health = {
        name                       = "AllowAppGatewayHealth"
        priority                   = 1020
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
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
  nsg_online_web = {
    name     = "nsg-online-web"
    rg_key   = "online_rg1"
    nsg_rules = {
      allow_https_from_dmz = {
        name                       = "AllowHTTPSFromDMZ"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.4.0.0/16"  # DMZ VNet
        destination_address_prefix = "*"
      }
      allow_http_from_dmz = {
        name                       = "AllowHTTPFromDMZ"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "10.4.0.0/16"
        destination_address_prefix = "*"
      }
      deny_direct_internet = {
        name                       = "DenyDirectInternet"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    }
  }
  nsg_online_app = {
    name     = "nsg-online-app"
    rg_key   = "online_rg2"
    nsg_rules = {
      allow_web_tier = {
        name                       = "AllowFromWebTier"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.3.1.0/24"  # Web subnet
        destination_address_prefix = "*"
      }
      deny_internet = {
        name                       = "DenyInternet"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    }
  }
  nsg_online_data = {
    name     = "nsg-online-data"
    rg_key   = "online_rg3"
    nsg_rules = {
      allow_app_tier = {
        name                       = "AllowFromAppTier"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.3.2.0/24"  # App subnet
        destination_address_prefix = "*"
      }
      deny_all_internet = {
        name                       = "DenyAllInternet"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    }
  }
  nsg_app_gateway = {
    name     = "nsg-app-gateway"
    rg_key   = "online_rg1"
    nsg_rules = {
      allow_internet_https = {
        name                       = "AllowInternetHTTPS"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
      allow_internet_http = {
        name                       = "AllowInternetHTTP"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
      allow_gateway_manager = {
        name                       = "AllowGatewayManager"
        priority                   = 1020
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      }
    }
  }
}
```

#### Route Tables

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `online_route_tables` | map(object) | Route table definitions | ✅ | See example below |

```hcl
online_route_tables = {
  rt_online_web = {
    name   = "rt-online-web"
    rg_key = "online_rg1"
    routes = {
      to_app_tier = {
        name                   = "ToAppTier"
        address_prefix         = "10.3.2.0/24"
        next_hop_type         = "VnetLocal"
        next_hop_in_ip_address = null
      }
      to_platform = {
        name                   = "ToPlatform"
        address_prefix         = "10.0.0.0/16"
        next_hop_type         = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"  # Azure Firewall IP
      }
    }
  }
  rt_online_app = {
    name   = "rt-online-app"
    rg_key = "online_rg2"
    routes = {
      to_data_tier = {
        name                   = "ToDataTier"
        address_prefix         = "10.3.3.0/24"
        next_hop_type         = "VnetLocal"
        next_hop_in_ip_address = null
      }
      default_route = {
        name                   = "DefaultToFirewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type         = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"
      }
    }
  }
  rt_online_dmz = {
    name   = "rt-online-dmz"
    rg_key = "online_rg1"
    routes = {
      to_web_tier = {
        name                   = "ToWebTier"
        address_prefix         = "10.3.1.0/24"
        next_hop_type         = "VirtualNetworkGateway"
        next_hop_in_ip_address = null
      }
    }
  }
}
```

### Application Gateway Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `application_gateways` | map(object) | Application Gateway definitions | ✅ | See example below |

```hcl
application_gateways = {
  appgw_online = {
    name               = "appgw-online-prod-01"
    rg_key            = "online_rg1"
    subnet_key        = "app_gateway_subnet"
    public_ip_name    = "pip-appgw-online-prod-01"
    sku_name          = "WAF_v2"
    sku_tier          = "WAF_v2"
    sku_capacity      = 2
    waf_enabled       = true
    waf_mode          = "Prevention"
    waf_rule_set_type = "OWASP"
    waf_rule_set_version = "3.2"
    
    backend_pools = {
      web_pool = {
        name = "web-backend-pool"
        backend_addresses = [
          {
            ip_address = "10.3.1.10"
          },
          {
            ip_address = "10.3.1.11"
          }
        ]
      }
    }
    
    listeners = {
      https_listener = {
        name               = "https-listener"
        frontend_port_name = "frontend-port-443"
        protocol           = "Https"
        ssl_certificate_name = "online-ssl-cert"
      }
      http_listener = {
        name               = "http-listener"
        frontend_port_name = "frontend-port-80"
        protocol           = "Http"
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
  online_to_platform = {
    peering_name                      = "peer-online-to-platform"
    vnet_name                        = "vnet-online-prod-01"
    remote_vnet_id                   = "/subscriptions/<platform-sub>/resourceGroups/TreyResearch-connectivity/providers/Microsoft.Network/virtualNetworks/vnet-platform-prod-01"
    rg_key                           = "online_rg1"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways             = true
  }
  dmz_to_platform = {
    peering_name                      = "peer-dmz-to-platform"
    vnet_name                        = "vnet-online-dmz-01"
    remote_vnet_id                   = "/subscriptions/<platform-sub>/resourceGroups/TreyResearch-connectivity/providers/Microsoft.Network/virtualNetworks/vnet-platform-prod-01"
    rg_key                           = "online_rg1"
    allow_virtual_network_access     = true
    allow_forwarded_traffic          = true
    allow_gateway_transit            = false
    use_remote_gateways             = false
  }
}
```

### Subscription and Environment Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `online_subscription_id` | string | Target subscription for online resources | ✅ | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"` |
| `platform_subscription_id` | string | Platform subscription for peering | ✅ | `"yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"` |
| `environment` | string | Environment identifier | ✅ | `"prod"` |
| `location` | string | Primary Azure region | ✅ | `"East US"` |

### Security and Compliance Configuration

| Variable | Type | Description | Required | Example |
|----------|------|-------------|----------|---------|
| `enable_ddos_protection` | bool | Enable DDoS protection | ❌ | `true` |
| `enable_waf` | bool | Enable Web Application Firewall | ✅ | `true` |
| `ssl_certificates` | map(object) | SSL certificate configurations | ✅ | See example below |

```hcl
ssl_certificates = {
  online_cert = {
    name           = "online-ssl-cert"
    key_vault_id   = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<kv>"
    secret_name    = "online-ssl-certificate"
  }
}

enable_ddos_protection = true
enable_waf = true
```

## 🚀 Deployment Instructions

### Prerequisites

1. **Platform Landing Zone** must be deployed first
2. **Management Resources** should be deployed for monitoring
3. Azure CLI installed and configured
4. Terraform >= 1.0 installed
5. SSL certificates available in Key Vault
6. Appropriate permissions in both online and platform subscriptions

### Step-by-Step Deployment

1. **Navigate to Online Landing Zone**
   ```zsh
   cd landing_zones/online
   ```

2. **Update Configuration**
   Edit `terraform.tfvars` with your specific values:
   ```zsh
   # Update subscription IDs
   online_subscription_id = "your-online-subscription-id"
   platform_subscription_id = "your-platform-subscription-id"
   
   # Update network addressing to avoid conflicts
   # Configure Application Gateway settings
   # Set up SSL certificates
   # Configure WAF rules
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

Use the automated workflow for consistent deployments:

```zsh
# Via GitHub CLI
gh workflow run "Deploy Selected Environment" \
  --field environment=online \
  --field action=apply \
  --field import_enabled=false
```

### Post-Deployment Configuration

1. **Configure DNS Records**
   ```zsh
   # Point your domain to the Application Gateway public IP
   az network public-ip show \
     --resource-group rg-online-prod-web \
     --name pip-appgw-online-prod-01 \
     --query ipAddress
   ```

2. **Upload SSL Certificates**
   ```zsh
   # Upload certificate to Key Vault
   az keyvault certificate import \
     --vault-name kv-online-certs \
     --name online-ssl-cert \
     --file certificate.pfx
   ```

3. **Configure WAF Rules**
   ```zsh
   # Review and customize WAF rules
   az network application-gateway waf-policy show \
     --resource-group rg-online-prod-web \
     --name waf-policy-online
   ```

## 🔍 Post-Deployment Validation

### Verify Resources

```zsh
# Check resource groups
az group list --subscription <online-subscription-id> --output table

# Check virtual networks
az network vnet list --subscription <online-subscription-id> --output table

# Check Application Gateway
az network application-gateway list --subscription <online-subscription-id> --output table

# Check public IPs
az network public-ip list --subscription <online-subscription-id> --output table

# Check VNet peering status
az network vnet peering list \
  --vnet-name vnet-online-prod-01 \
  --resource-group rg-online-prod-web \
  --output table
```

### Internet Connectivity Tests

```zsh
# Test public endpoint
curl -I https://your-domain.com

# Test WAF protection
curl -X POST https://your-domain.com/test?param=<script>alert('xss')</script>

# Test SSL certificate
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Test load balancing
for i in {1..10}; do curl -s https://your-domain.com | grep "Server"; done
```

### Security Validation

```zsh
# Test DDoS protection status
az network ddos-protection-plan show \
  --resource-group rg-online-prod-web \
  --name ddos-protection-plan

# Review WAF logs
az monitor log-analytics query \
  --workspace <workspace-id> \
  --analytics-query "AzureDiagnostics | where Category == 'ApplicationGatewayFirewallLog'"

# Check NSG flow logs
az network watcher flow-log show \
  --resource-group NetworkWatcherRG \
  --name nsg-online-dmz-flowlog
```

## 🔧 Customization Examples

### Adding CDN Integration

```hcl
cdn_profiles = {
  online_cdn = {
    name                = "cdn-online-prod"
    rg_key             = "online_rg1"
    sku                = "Standard_Microsoft"
    
    endpoints = {
      web_endpoint = {
        name           = "online-web"
        origin_host_header = "your-domain.com"
        origins = [
          {
            name      = "appgw-origin"
            host_name = "your-appgw-ip"
          }
        ]
      }
    }
  }
}
```

### Custom WAF Rules

```hcl
waf_custom_rules = {
  block_specific_countries = {
    name     = "BlockSpecificCountries"
    priority = 100
    rule_type = "MatchRule"
    action   = "Block"
    
    match_conditions = [
      {
        match_variable = "RemoteAddr"
        operator       = "GeoMatch"
        match_values   = ["CN", "RU"]  # Block China and Russia
      }
    ]
  }
  
  rate_limit_rule = {
    name     = "RateLimitRule"
    priority = 200
    rule_type = "RateLimitRule"
    action   = "Block"
    
    match_conditions = [
      {
        match_variable = "RemoteAddr"
        operator       = "IPMatch"
        match_values   = ["0.0.0.0/0"]
      }
    ]
    
    rate_limit_duration = "PT1M"
    rate_limit_threshold = 100
  }
}
```

### Multi-Site Configuration

```hcl
application_gateways = {
  appgw_multi_site = {
    # ...existing configuration...
    
    listeners = {
      site1_listener = {
        name               = "site1-listener"
        frontend_port_name = "frontend-port-443"
        protocol           = "Https"
        host_name          = "site1.company.com"
        ssl_certificate_name = "site1-ssl-cert"
      }
      site2_listener = {
        name               = "site2-listener"
        frontend_port_name = "frontend-port-443"
        protocol           = "Https"
        host_name          = "site2.company.com"
        ssl_certificate_name = "site2-ssl-cert"
      }
    }
    
    backend_pools = {
      site1_pool = {
        name = "site1-backend-pool"
        backend_addresses = [
          { ip_address = "10.3.1.10" },
          { ip_address = "10.3.1.11" }
        ]
      }
      site2_pool = {
        name = "site2-backend-pool"
        backend_addresses = [
          { ip_address = "10.3.1.20" },
          { ip_address = "10.3.1.21" }
        ]
      }
    }
  }
}
```

## 🔒 Security and Compliance

### Internet-Facing Security

- **Web Application Firewall**: OWASP rule set protection
- **DDoS Protection**: Azure DDoS Protection Standard
- **SSL/TLS Termination**: End-to-end encryption
- **Network Segmentation**: DMZ isolation from internal networks
- **IP Filtering**: Geographic and IP-based restrictions

### Compliance Features

- **Audit Logging**: Comprehensive logging for all internet-facing resources
- **Data Protection**: Encryption in transit and at rest
- **Access Control**: Strict RBAC for internet-facing resources
- **Monitoring**: Real-time threat detection and alerting
- **Incident Response**: Automated response to security events

### Security Best Practices

1. **Implement Defense in Depth**: Multiple security layers
2. **Regular Security Assessments**: Penetration testing and vulnerability scans
3. **WAF Rule Tuning**: Regular review and updates of WAF rules
4. **SSL Certificate Management**: Automated certificate renewal
5. **Traffic Analysis**: Continuous monitoring of traffic patterns
6. **Incident Response Plan**: Documented procedures for security incidents

## 📊 Monitoring and Alerting

### Key Metrics to Monitor

| Metric | Resource Type | Threshold | Action |
|--------|--------------|-----------|---------|
| Request Rate | Application Gateway | > 10,000 req/min | Scale out |
| Response Time | Application Gateway | > 5 seconds | Investigate performance |
| Failed Requests | Application Gateway | > 5% | Check backend health |
| WAF Blocked Requests | WAF | > 100/min | Review security logs |
| DDoS Attacks | DDoS Protection | Any attack | Activate incident response |
| SSL Certificate Expiry | Key Vault | < 30 days | Renew certificate |

### Monitoring Configuration

```hcl
monitor_action_groups = {
  online_alerts = {
    name     = "online-production-alerts"
    rg_key   = "online_rg1"
    
    email_receivers = [
      {
        name          = "WebTeam"
        email_address = "webteam@company.com"
      }
    ]
    
    sms_receivers = [
      {
        name         = "OnCallEngineer"
        country_code = "1"
        phone_number = "5551234567"
      }
    ]
  }
}

metric_alerts = {
  high_request_rate = {
    name        = "HighRequestRate"
    rg_key      = "online_rg1"
    description = "High request rate detected"
    
    criteria = {
      metric_name      = "Requests"
      metric_namespace = "Microsoft.Network/applicationGateways"
      aggregation      = "Total"
      operator         = "GreaterThan"
      threshold        = 10000
    }
    
    frequency   = "PT1M"
    window_size = "PT5M"
    severity    = 2
  }
}
```

### Log Analytics Queries

```kql
// Application Gateway requests by status code
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS"
| where Category == "ApplicationGatewayAccessLog"
| summarize count() by httpStatus_d, bin(TimeGenerated, 5m)
| render timechart

// WAF blocked requests
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS"
| where Category == "ApplicationGatewayFirewallLog"
| where action_s == "Blocked"
| summarize count() by ruleId_s, bin(TimeGenerated, 5m)

// Top requesting IPs
AzureDiagnostics
| where ResourceType == "APPLICATIONGATEWAYS"
| where Category == "ApplicationGatewayAccessLog"
| summarize RequestCount = count() by clientIP_s
| top 10 by RequestCount desc
```

## 🚨 Troubleshooting

### Common Issues

| Issue | Symptoms | Resolution |
|-------|----------|------------|
| SSL Certificate Issues | HTTPS not working | Check certificate installation and binding |
| WAF False Positives | Legitimate requests blocked | Review and tune WAF rules |
| Backend Connectivity | 502/503 errors | Check backend pool health and NSG rules |
| DNS Resolution | Domain not resolving | Verify DNS records and TTL settings |
| Performance Issues | Slow response times | Check Application Gateway capacity and backend performance |

### Debug Commands

```zsh
# Check Application Gateway backend health
az network application-gateway show-backend-health \
  --name appgw-online-prod-01 \
  --resource-group rg-online-prod-web

# Review WAF logs
az monitor log-analytics query \
  --workspace <workspace-id> \
  --analytics-query "AzureDiagnostics | where Category == 'ApplicationGatewayFirewallLog' | limit 50"

# Test backend connectivity
az network application-gateway probe create \
  --gateway-name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --name custom-probe \
  --protocol Http \
  --path /health

# Check public IP configuration
az network public-ip show \
  --resource-group rg-online-prod-web \
  --name pip-appgw-online-prod-01

# Verify SSL certificate
az network application-gateway ssl-cert show \
  --gateway-name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --name online-ssl-cert
```

### Performance Optimization

```zsh
# Enable autoscaling
az network application-gateway update \
  --name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --min-capacity 2 \
  --max-capacity 10

# Configure connection draining
az network application-gateway http-settings update \
  --gateway-name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --name appGatewayBackendHttpSettings \
  --connection-draining-timeout 60

# Enable HTTP/2
az network application-gateway http-listener update \
  --gateway-name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --name https-listener \
  --frontend-port frontendport443 \
  --protocol Http2
```

## 🔄 Maintenance and Updates

### Regular Maintenance Tasks

- **Certificate Renewal**: Monitor and renew SSL certificates
- **WAF Rule Updates**: Review and update WAF rules monthly
- **Performance Monitoring**: Analyze performance metrics weekly
- **Security Reviews**: Conduct security assessments quarterly
- **Backup Verification**: Test backup and recovery procedures
- **Capacity Planning**: Review capacity requirements quarterly

### Update Procedures

```zsh
# Update Application Gateway SKU
az network application-gateway update \
  --name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --sku WAF_v2 \
  --capacity 3

# Update WAF policy
az network application-gateway waf-policy update \
  --name waf-policy-online \
  --resource-group rg-online-prod-web \
  --mode Prevention

# Update backend pool members
az network application-gateway address-pool update \
  --gateway-name appgw-online-prod-01 \
  --resource-group rg-online-prod-web \
  --name web-backend-pool \
  --servers 10.3.1.10 10.3.1.11 10.3.1.12
```

## 📈 Scaling and Performance

### Horizontal Scaling

- **Application Gateway**: Auto-scaling based on traffic
- **Backend Services**: Scale sets for web and app tiers
- **Database**: Read replicas for improved performance
- **CDN**: Global content distribution

### Vertical Scaling

- **Application Gateway**: Upgrade SKU for higher performance
- **Virtual Machines**: Increase VM sizes for backend services
- **Database**: Scale up database compute and storage

### Performance Optimization

```hcl
# Application Gateway performance settings
application_gateway_performance = {
  enable_http2           = true
  request_timeout        = 30
  connection_draining    = true
  cookie_based_affinity  = "Disabled"
  
  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 10
  }
  
  waf_configuration = {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
    
    disabled_rule_groups = []
    exclusions = []
  }
}
```

## 🤝 Dependencies

### Platform Landing Zone Dependencies

- Azure Firewall IP address for route tables
- Platform VNet IDs for peering
- Shared services (DNS, monitoring)
- Key Vault for certificate storage

### External Dependencies

- Domain registration and DNS management
- SSL certificate authority
- Content delivery network (optional)
- Third-party security services (optional)

## 📋 Outputs

The Online Landing Zone provides these outputs:

| Output | Description | Usage |
|--------|-------------|-------|
| `online_vnet_ids` | Online VNet resource IDs | For additional peering or service integration |
| `application_gateway_public_ip` | Application Gateway public IP address | For DNS configuration |
| `application_gateway_fqdn` | Application Gateway FQDN | For domain setup |
| `waf_policy_id` | WAF policy resource ID | For security rule management |
| `backend_pool_ids` | Backend pool resource IDs | For application deployment |
| `ssl_certificate_ids` | SSL certificate resource IDs | For certificate management |

## 🌐 Integration Examples

### Azure Front Door Integration

```hcl
front_door_profiles = {
  online_frontdoor = {
    name     = "fd-online-prod"
    rg_key   = "online_rg1"
    sku_name = "Premium_AzureFrontDoor"
    
    endpoints = {
      online_endpoint = {
        name = "online-prod"
        origin_groups = {
          primary = {
            name = "primary-origin-group"
            origins = {
              appgw_origin = {
                name                = "application-gateway"
                host_name          = "your-appgw-fqdn"
                certificate_name_check_enabled = true
              }
            }
          }
        }
      }
    }
  }
}
```

This comprehensive Online Landing Zone configuration provides a secure, scalable, and well-monitored environment for internet-facing applications while maintaining integration with the overall Azure Landing Zone architecture.
