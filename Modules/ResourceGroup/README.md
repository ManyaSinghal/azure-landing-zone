# Azure Resource Group Module

This Terraform module creates an Azure Resource Group with customizable configuration for tagging and location management.

## Overview

The Azure Resource Group module provides a standardized way to create and manage Azure Resource Groups across your infrastructure. It supports proper tagging, location configuration, and outputs essential information for use by other modules.

## Features

- ✅ Azure Resource Group creation
- ✅ Flexible location configuration
- ✅ Comprehensive tagging support
- ✅ Multiple output values for integration
- ✅ Version constraints for stability

## Usage

### Basic Usage

```hcl
module "resource_group" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-myapp-prod-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    CostCenter  = "IT-001"
  }
}
```

### Advanced Usage with Multiple Resource Groups

```hcl
# Production Resource Group
module "rg_production" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-myapp-prod-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    CostCenter  = "IT-001"
    Backup      = "Required"
  }
}

# Development Resource Group
module "rg_development" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-myapp-dev-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Development"
    Project     = "MyApplication"
    Owner       = "Development Team"
    CostCenter  = "IT-002"
    AutoShutdown = "Enabled"
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
| [azurerm_resource_group.az_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|----------|---------|
| resource_group_name | Name of the Azure Resource Group | `string` | `""` | ✅ | `"rg-myapp-prod-eastus2"` |
| location | The Azure Region where the Resource Group will be created | `string` | `""` | ✅ | `"East US 2"` |
| rg_tags | A mapping of tags to assign to the Resource Group | `map(string)` | `{}` | ❌ | `{"Environment": "Production"}` |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| az_resource_group_id | The ID of the Resource Group | `string` |
| az_resource_group_name | The name of the Resource Group | `string` |
| az_resource_group_location | The location of the Resource Group | `string` |
| az_resource_group_tags | The tags assigned to the Resource Group | `map(string)` |

## Example Implementation

See the [Example](./Example/) directory for a complete implementation example.

### Example Files Structure
```
Example/
├── README.md           # Example-specific documentation
├── main.tf            # Module usage example
├── var.tf             # Variable definitions
└── values.auto.tfvars # Example variable values
```

## Naming Conventions

### Recommended Resource Group Naming Pattern
```
rg-{workload}-{environment}-{region}
```

**Examples:**
- `rg-webapp-prod-eastus2`
- `rg-database-dev-westus2`
- `rg-platform-shared-centralus`

### Common Environments
- `prod` - Production
- `dev` - Development
- `test` - Testing
- `stage` - Staging
- `shared` - Shared resources

## Tagging Strategy

### Required Tags
| Tag | Description | Example |
|-----|-------------|---------|
| Environment | Deployment environment | `Production`, `Development`, `Testing` |
| Project | Project or application name | `MyWebApp`, `DataPlatform` |
| Owner | Team or individual responsible | `Platform Team`, `john.doe@company.com` |
| CostCenter | Cost allocation identifier | `IT-001`, `Marketing-002` |

### Optional Tags
| Tag | Description | Example |
|-----|-------------|---------|
| Backup | Backup requirements | `Required`, `Optional`, `None` |
| AutoShutdown | Auto-shutdown configuration | `Enabled`, `Disabled` |
| Compliance | Compliance requirements | `PCI`, `HIPAA`, `SOX` |
| DataClassification | Data sensitivity level | `Public`, `Internal`, `Confidential`, `Restricted` |

## Integration Examples

### Using with Network Module
```hcl
module "resource_group" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-network-hub-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Shared"
    Project     = "NetworkHub"
    Owner       = "Network Team"
  }
}

module "virtual_network" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  resource_group_name  = module.resource_group.az_resource_group_name
  location            = module.resource_group.az_resource_group_location
  virtual_network_name = "vnet-hub-eastus2"
  address_space       = ["10.0.0.0/16"]
  tags               = module.resource_group.az_resource_group_tags
}
```

### Using with Storage Module
```hcl
module "resource_group" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-storage-prod-eastus2"
  location           = "East US 2"
  rg_tags = {
    Environment = "Production"
    Project     = "DataLake"
    Owner       = "Data Team"
  }
}

module "storage_account" {
  source = "./Modules/AzureStorage/storage_account"
  
  resource_group_name      = module.resource_group.az_resource_group_name
  location                = module.resource_group.az_resource_group_location
  storage_account_name     = "stdatalakeprod001"
  account_tier            = "Standard"
  account_replication_type = "GRS"
  tags                    = module.resource_group.az_resource_group_tags
}
```

## Best Practices

### 1. Naming Conventions
- Use consistent naming patterns across all environments
- Include environment and region in the name
- Use lowercase with hyphens for readability
- Avoid special characters except hyphens

### 2. Tagging Strategy
- Implement a comprehensive tagging strategy from day one
- Use tags for cost allocation and resource management
- Standardize tag names and values across the organization
- Include automation-friendly tags (e.g., AutoShutdown, Backup)

### 3. Location Management
- Choose regions based on data residency requirements
- Consider paired regions for disaster recovery
- Use region abbreviations consistently (e.g., eastus2, westus2)

### 4. Resource Organization
- Group related resources in the same Resource Group
- Consider lifecycle management when grouping resources
- Separate production and non-production resources
- Use separate Resource Groups for different environments

## Troubleshooting

### Common Issues

#### 1. Resource Group Already Exists
```bash
Error: A resource with the ID "/subscriptions/.../resourceGroups/rg-myapp-prod" already exists
```

**Solution:** Check if the Resource Group already exists or use a different name.

```bash
az group show --name "rg-myapp-prod" --output table
```

#### 2. Invalid Location
```bash
Error: The location 'invalid-location' is not valid
```

**Solution:** Use a valid Azure region name.

```bash
# List available locations
az account list-locations --output table
```

#### 3. Permission Issues
```bash
Error: Authorization failed when calling the Microsoft.Resources/subscriptions/resourceGroups API
```

**Solution:** Ensure the service principal has appropriate permissions.

Required permissions:
- `Contributor` role at subscription level, or
- `Resource Group Contributor` role at subscription level

### Validation Commands

```bash
# Check if Resource Group was created successfully
az group show --name "rg-myapp-prod-eastus2" --output table

# List all resources in the Resource Group
az resource list --resource-group "rg-myapp-prod-eastus2" --output table

# Validate Resource Group tags
az group show --name "rg-myapp-prod-eastus2" --query tags
```

## Security Considerations

### 1. Access Control
- Implement least privilege access using RBAC
- Use Azure AD groups for role assignments
- Regular access reviews and cleanup

### 2. Resource Policies
- Implement Azure Policy to enforce naming conventions
- Use policies to enforce required tags
- Set up policies for allowed locations

### 3. Monitoring
- Enable activity logging for Resource Group operations
- Set up alerts for Resource Group modifications
- Monitor resource creation and deletion

## Migration and Maintenance

### Moving Resources Between Resource Groups
```bash
# Move resources to a different Resource Group
az resource move --destination-group "rg-destination" \
  --ids "/subscriptions/.../resourceGroups/rg-source/providers/Microsoft.Compute/virtualMachines/vm1"
```

### Resource Group Cleanup
```bash
# Delete empty Resource Group
az group delete --name "rg-obsolete" --yes --no-wait
```

## Contributing

When contributing to this module:

1. Follow the established naming conventions
2. Update documentation for any new features
3. Add appropriate examples
4. Test changes in a development environment
5. Update version constraints if needed

## Support

For issues and questions:
- Check the troubleshooting section above
- Review Azure Resource Group documentation
- Contact the Platform Engineering team

---

**Module Version:** 1.0.0  
**Last Updated:** June 2025  
**Terraform Version:** >= 1.0  
**Provider Version:** azurerm ~> 3.0
