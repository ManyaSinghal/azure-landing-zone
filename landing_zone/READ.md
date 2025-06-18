# READ.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Azure Landing Zone Terraform project that implements a multi-subscription Enterprise Scale architecture with:
- **Platform Landing Zone**: Core management groups, policies, connectivity (hub), management, and identity
- **Corp Landing Zone**: Internal corporate workloads with domain-joined VMs
- **Online Landing Zone**: Internet-facing workloads with web applications and databases

## Key Commands

### Deployment
```powershell
# Deploy entire landing zone architecture
.\Deploy.ps1

# Deploy specific components (use terraform targets)
terraform plan -var-file .\Platformconfig.tfvars -target='module.managementgroups'
terraform apply -var-file .\Platformconfig.tfvars -target='module.platform_connectivity' -auto-approve
```

### Terraform Operations
```bash
# Initialize (required after module changes)
terraform init

# Plan with specific config
terraform plan -var-file ./Platformconfig.tfvars

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive
```

### Cleanup
```powershell
# Destroy entire infrastructure
.\Destroy.ps1
```

## Architecture Structure

### Multi-Subscription Model
- **Platform Subscription**: Houses shared services (connectivity, management, identity)
- **Corp Subscription**: Corporate landing zone workloads  
- **Online Subscription**: Public-facing workloads
- Uses separate Azure providers with aliases (`azurerm.corp`, `azurerm.online`)

### Module Dependencies
Critical deployment order enforced through `depends_on`:
1. **Management Groups** → **Policies** (governance foundation)
2. **Platform Connectivity** → **Platform Management** (shared services)
3. **Platform Identity** (depends on connectivity for subnet placement)
4. **Landing Zones** (depend on platform components)
5. **VNet Peering** (connects spokes to hub)

### Configuration Files
- `Platformconfig.tfvars`: Main configuration for platform and shared settings
- `corpconfig.tfvars`: Corp-specific overrides (optional)
- `onlineconfig.tfvars`: Online-specific overrides (optional)
- `provider.tf`: Multi-subscription provider configuration with remote state

### Module Architecture
- **Platform modules**: `platform-connectivity`, `platform-management`, `identity`
- **Landing zone modules**: `corp-landing-zone`, `online-landing-zone`
- **Shared modules**: `managementgroups`, `Policies`, `resourcegroups`, `vnet-peering`
- **Gateway modules**: `vpngateway`, `expressroute`

## Important Configuration Patterns

### Conditional Deployment
Most modules use count-based conditional deployment:
```hcl
count = var.deploy_platform_connectivity ? 1 : 0
```

### Cross-Module References
Platform outputs are referenced by landing zones:
```hcl
firewall_private_ip = module.platform_connectivity[0].firewall_private_ip
log_analytics_workspace_id = module.platform_management[0].log_analytics_workspace_id
```

### Subnet ID Resolution
Identity module uses conditional subnet selection based on deployment model:
```hcl
ident_dc_subnet_id = var.deploy_lzvirtualnetwork ? data.azurerm_subnet.dc_subnet[0].id : module.platform_connectivity[0].subnet_ids["snet-platform-mgmt"]
```

## Deployment Strategy

The `Deploy.ps1` script implements a staged deployment approach:
1. Management Groups and Policies (governance)
2. Platform Core (connectivity, management)  
3. Identity (domain controllers)
4. Gateways (VPN/ExpressRoute)
5. Corp Landing Zone
6. Online Landing Zone
7. VNet Peering

Each stage requires manual confirmation and can be skipped if not needed.

## Security Considerations

- Remote state stored in separate tenant (configured in `provider.tf`)
- Sensitive values should use environment variables, not tfvars
- Service principal authentication for cross-tenant state access
- Default passwords in config files should be changed for production

## Common Issues

### Module Path Case Sensitivity
- Module sources use lowercase paths: `./modules/policies`
- Actual directories use mixed case: `./Modules/Policies`
- Ensure consistency when adding new modules

### Provider Configuration
- Each landing zone requires proper provider alias configuration
- Subscription IDs must be valid and accessible
- Service principal needs permissions across all target subscriptions

### Variable Dependencies
- Some variables (like `ident_dc_subnet_id`) are only required when specific modules are deployed
- Use default values for optional cross-module dependencies