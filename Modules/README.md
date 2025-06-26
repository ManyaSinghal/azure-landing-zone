# Azure Terraform Modules

This directory contains reusable Terraform modules for Azure resources, designed to support the Azure Landing Zone implementation with consistent, secure, and well-documented infrastructure components.

## 📦 Available Modules

| Category | Module | Description | Status | Documentation |
|----------|--------|-------------|--------|---------------|
| **Core** | [ResourceGroup](./ResourceGroup/README.md) | Azure Resource Group management | ✅ Available | Complete |
| **Networking** | [AzureNetwork](./AzureNetwork/README.md) | VNet, Subnets, NSG, Peering, Firewall | ✅ Available | Complete |
| **Compute** | [AzureCompute](./AzureCompute/README.md) | Virtual Machines, Scale Sets | ✅ Available | Complete |
| **Storage** | [AzureStorage](./AzureStorage/README.md) | Storage Accounts, Blob, Files | ✅ Available | Complete |
| **Security** | [AzureKeyVault](./AzureKeyVault/README.md) | Key Vault, Certificates, Secrets | ✅ Available | Complete |
| **Database** | [AzureDatabase](./AzureDatabase/README.md) | SQL Server, SQL Database | ✅ Available | Complete |
| **Monitoring** | [AzureMonitor](./AzureMonitor/README.md) | Diagnostic Settings, Alerts | ✅ Available | Complete |
| **Analytics** | [AzureLogAnalytics](./AzureLogAnalytics/README.md) | Log Analytics Workspace | ✅ Available | Complete |
| **Insights** | [AzureApplicationInsights](./AzureApplicationInsights/README.md) | Application Insights | ✅ Available | Complete |
| **Web Apps** | [AzureWebApps](./AzureWebApps/README.md) | App Service, Function Apps | ✅ Available | Complete |
| **Management** | [AzureMgmt](./AzureMgmt/README.md) | Management Groups, Policies | ✅ Available | Complete |
| **Backup** | [Azure_backup](./Azure_backup/README.md) | Recovery Services Vault | ✅ Available | Complete |

## 🏗️ Module Structure

Each module follows a consistent structure for maintainability and ease of use:

```
ModuleName/
├── README.md              # Comprehensive module documentation
├── main.tf               # Main resource definitions
├── variables.tf          # Input variables with validation
├── outputs.tf           # Output values
├── versions.tf          # Provider and version constraints
├── data.tf              # Data sources (if needed)
└── Example/             # Usage examples and tests
    ├── main.tf          # Example implementation
    ├── variables.tf     # Example variables
    ├── terraform.tfvars # Sample values
    └── README.md        # Example documentation
```

## 🚀 Quick Start

### Basic Module Usage

```hcl
# Example: Using the ResourceGroup module
module "resource_group" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-example-prod-001"
  location           = "East US"
  rg_tags = {
    Environment = "Production"
    Owner       = "Platform Team"
    CostCenter  = "IT-Operations"
    Workload    = "Infrastructure"
  }
}
```

### Advanced Module Usage with Dependencies

```hcl
# Example: Network infrastructure with dependencies
module "resource_group" {
  source = "./Modules/ResourceGroup"
  
  resource_group_name = "rg-network-prod"
  location           = "East US"
  rg_tags = local.common_tags
}

module "virtual_network" {
  source = "./Modules/AzureNetwork/virtual_network"
  
  virtual_network_name = "vnet-prod-001"
  resource_group_name  = module.resource_group.resource_group_name
  location            = module.resource_group.location
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = ["10.0.1.4", "10.0.1.5"]
  
  tags = local.common_tags
  
  depends_on = [module.resource_group]
}

module "subnet" {
  source = "./Modules/AzureNetwork/subnet"
  
  subnet_name           = "snet-web-prod"
  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = module.virtual_network.virtual_network_name
  subnet_address_prefix = ["10.0.1.0/24"]
  
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
  
  depends_on = [module.virtual_network]
}
```

### Module Versioning

```hcl
# Using specific module versions for production
module "resource_group" {
  source = "git::https://github.com/your-org/azure-landing-zone.git//Modules/ResourceGroup?ref=v2.1.0"
  
  # Module configuration
  resource_group_name = "rg-prod-app"
  location           = "East US"
  rg_tags           = local.tags
}
```

## 📋 Module Development Standards

### Naming Conventions

| Component | Convention | Example |
|-----------|------------|---------|
| **Module Directory** | PascalCase | `ResourceGroup`, `AzureNetwork` |
| **File Names** | snake_case | `main.tf`, `variables.tf`, `outputs.tf` |
| **Resource Names** | kebab-case with prefixes | `rg-platform-prod`, `vnet-hub-001` |
| **Variable Names** | snake_case | `resource_group_name`, `vnet_address_space` |
| **Output Names** | snake_case | `resource_group_id`, `virtual_network_name` |

### Required Files

Every module must include these files:

| File | Purpose | Required |
|------|---------|----------|
| `README.md` | Complete documentation with examples | ✅ |
| `main.tf` | Resource definitions and logic | ✅ |
| `variables.tf` | Input variables with descriptions | ✅ |
| `outputs.tf` | Output values for module consumers | ✅ |
| `versions.tf` | Provider and Terraform version constraints | ✅ |
| `data.tf` | Data sources (if applicable) | ❌ |
| `Example/` | Working examples and test cases | ✅ |

### Variable Standards

All variables must follow this structure:

```hcl
variable "example_variable" {
  type        = string
  description = "Clear, comprehensive description of the variable purpose and expected values"
  default     = null
  
  validation {
    condition     = length(var.example_variable) > 0
    error_message = "The example_variable must not be empty."
  }
}
```

### Output Standards

```hcl
output "resource_id" {
  description = "The resource ID of the created resource"
  value       = azurerm_resource.example.id
}

output "resource_name" {
  description = "The name of the created resource"
  value       = azurerm_resource.example.name
}
```

## 🔧 Module Categories Deep Dive

### Core Infrastructure Modules

#### ResourceGroup
- **Purpose**: Centralized resource group management
- **Features**: Consistent tagging, location validation, naming conventions
- **Dependencies**: None
- **Usage**: Foundation for all other modules

#### AzureNetwork
- **Purpose**: Network infrastructure components
- **Features**: VNets, Subnets, NSGs, Route Tables, Peering, Firewalls
- **Dependencies**: ResourceGroup
- **Usage**: Hub-spoke topology, security segmentation

### Compute Modules

#### AzureCompute
- **Purpose**: Virtual machine and scale set management
- **Features**: Windows/Linux VMs, VM Scale Sets, Availability Sets
- **Dependencies**: ResourceGroup, AzureNetwork
- **Usage**: Application hosting, domain controllers

### Storage Modules

#### AzureStorage
- **Purpose**: Storage account and blob management
- **Features**: Storage accounts, containers, file shares, access policies
- **Dependencies**: ResourceGroup, optionally AzureNetwork
- **Usage**: Application data, diagnostic logs, backup storage

### Security Modules

#### AzureKeyVault
- **Purpose**: Secrets, keys, and certificate management
- **Features**: Key Vault, access policies, secrets, certificates, keys
- **Dependencies**: ResourceGroup, AzureNetwork (for private endpoints)
- **Usage**: Certificate storage, application secrets, encryption keys

### Database Modules

#### AzureDatabase
- **Purpose**: Database services management
- **Features**: SQL Server, SQL Database, elastic pools, firewall rules
- **Dependencies**: ResourceGroup, AzureNetwork
- **Usage**: Application databases, data warehousing

### Monitoring Modules

#### AzureMonitor
- **Purpose**: Monitoring and diagnostic capabilities
- **Features**: Diagnostic settings, action groups, alert rules
- **Dependencies**: ResourceGroup, AzureLogAnalytics
- **Usage**: Resource monitoring, alerting, diagnostics

#### AzureLogAnalytics
- **Purpose**: Log Analytics workspace management
- **Features**: Workspaces, solutions, saved searches, data retention
- **Dependencies**: ResourceGroup
- **Usage**: Centralized logging, monitoring dashboards

#### AzureApplicationInsights
- **Purpose**: Application performance monitoring
- **Features**: Application Insights, web tests, alerts
- **Dependencies**: ResourceGroup, AzureLogAnalytics
- **Usage**: Application monitoring, performance analysis

### Web Application Modules

#### AzureWebApps
- **Purpose**: Web application hosting
- **Features**: App Service Plans, Web Apps, Function Apps, deployment slots
- **Dependencies**: ResourceGroup, optionally AzureKeyVault
- **Usage**: Web application hosting, serverless functions

### Management Modules

#### AzureMgmt
- **Purpose**: Governance and management
- **Features**: Management Groups, Policy Definitions, Policy Assignments
- **Dependencies**: None (tenant-level resources)
- **Usage**: Organizational hierarchy, compliance enforcement

#### Azure_backup
- **Purpose**: Backup and recovery services
- **Features**: Recovery Services Vault, backup policies, backup items
- **Dependencies**: ResourceGroup
- **Usage**: VM backup, file share backup, disaster recovery

## 🔄 CI/CD Integration

### GitHub Actions Integration

The modules are designed to work seamlessly with GitHub Actions workflows:

```yaml
# Example workflow for module testing
name: Module Validation

on:
  pull_request:
    paths:
      - 'Modules/**'

jobs:
  validate-modules:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0
      
      - name: Terraform Format Check
        run: terraform fmt -check -recursive Modules/
      
      - name: Terraform Validate
        run: |
          find Modules -name "*.tf" -path "*/Example/*" -prune -o -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
            cd "$dir"
            terraform init -backend=false
            terraform validate
            cd - > /dev/null
          done
```

### Module Testing Strategy

```hcl
# Example test configuration
module "test_resource_group" {
  source = "../"
  
  resource_group_name = "rg-test-${random_id.test.hex}"
  location           = "East US"
  rg_tags = {
    Environment = "Test"
    Purpose     = "Module Testing"
    AutoDelete  = "true"
  }
}

resource "random_id" "test" {
  byte_length = 4
}

output "test_resource_group_id" {
  value = module.test_resource_group.resource_group_id
}
```

## 📖 Module Documentation Template

Each module README should include:

### 1. Overview Section
```markdown
# Module Name

Brief description of module purpose and functionality.

## Features
- Feature 1
- Feature 2
- Feature 3
```

### 2. Usage Examples
```markdown
## Usage Examples

### Basic Usage
```hcl
module "example" {
  source = "./path/to/module"
  
  # Required variables
  required_var = "value"
}
```

### Advanced Usage
```hcl
# More complex example with optional parameters
```

### 3. Variables Table
```markdown
## Variables

| Name | Type | Description | Required | Default | Example |
|------|------|-------------|----------|---------|---------|
| `var_name` | `string` | Variable description | ✅ | `null` | `"example"` |
```

### 4. Outputs Table
```markdown
## Outputs

| Name | Description | Type |
|------|-------------|------|
| `output_name` | Output description | `string` |
```

### 5. Requirements Section
```markdown
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |
```

## 🔍 Module Quality Checklist

Before releasing a module, ensure it meets these criteria:

### ✅ Code Quality
- [ ] Terraform formatting applied (`terraform fmt`)
- [ ] Terraform validation passed (`terraform validate`)
- [ ] No hardcoded values
- [ ] Proper variable validation
- [ ] Meaningful variable descriptions
- [ ] Comprehensive outputs

### ✅ Documentation
- [ ] Complete README with examples
- [ ] Variable table with descriptions
- [ ] Output table with descriptions
- [ ] Usage examples provided
- [ ] Requirements documented

### ✅ Testing
- [ ] Example directory with working code
- [ ] Module tested in isolation
- [ ] Integration testing completed
- [ ] No terraform warnings or errors

### ✅ Security
- [ ] No secrets in code
- [ ] Secure defaults applied
- [ ] Network security considered
- [ ] Access controls implemented

### ✅ Best Practices
- [ ] Follows naming conventions
- [ ] Proper resource tagging
- [ ] Idempotent operations
- [ ] Error handling implemented

## 🚨 Common Issues and Solutions

### Module Development Issues

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Circular Dependencies** | Terraform cannot determine order | Restructure modules, use data sources |
| **State Conflicts** | Resources already exist errors | Use terraform import or different names |
| **Provider Version Conflicts** | Version constraint errors | Align provider versions across modules |
| **Variable Type Mismatches** | Terraform type validation errors | Check variable types and formats |

### Usage Issues

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Module Not Found** | Module source path errors | Verify module path and structure |
| **Missing Variables** | Required variable errors | Check module documentation for required vars |
| **Output Reference Errors** | Cannot reference module outputs | Ensure outputs are defined in module |
| **Permission Issues** | Azure authentication errors | Verify service principal permissions |

## 🔧 Development Workflow

### Creating a New Module

1. **Create Module Structure**
   ```zsh
   mkdir -p Modules/NewModule/Example
   cd Modules/NewModule
   
   # Create required files
   touch main.tf variables.tf outputs.tf versions.tf README.md
   touch Example/main.tf Example/variables.tf Example/terraform.tfvars Example/README.md
   ```

2. **Implement Module Logic**
   - Define resources in `main.tf`
   - Add variables with validation in `variables.tf`
   - Define outputs in `outputs.tf`
   - Set provider constraints in `versions.tf`

3. **Create Documentation**
   - Write comprehensive README
   - Include usage examples
   - Document all variables and outputs
   - Add troubleshooting guidance

4. **Test Module**
   - Create working example in `Example/` directory
   - Test with `terraform plan` and `terraform apply`
   - Verify outputs and functionality
   - Test edge cases and error conditions

5. **Review and Release**
   - Code review by peers
   - Security review
   - Documentation review
   - Tag release version

### Module Update Process

1. **Backward Compatibility**
   - Avoid breaking changes when possible
   - Use semantic versioning (MAJOR.MINOR.PATCH)
   - Document breaking changes clearly

2. **Testing Updates**
   - Test with existing implementations
   - Verify examples still work
   - Check for unintended side effects

3. **Documentation Updates**
   - Update README with new features
   - Update examples if needed
   - Update variable/output tables

## 🤝 Contributing Guidelines

### Code Standards

- Follow Terraform best practices
- Use consistent naming conventions
- Include comprehensive documentation
- Add working examples
- Implement proper error handling

### Review Process

1. **Technical Review**
   - Code functionality and efficiency
   - Terraform best practices adherence
   - Security considerations
   - Performance implications

2. **Documentation Review**
   - Clarity and completeness
   - Example accuracy
   - Variable/output documentation
   - Troubleshooting guidance

3. **Testing Review**
   - Example functionality
   - Edge case coverage
   - Integration testing
   - Performance testing

## 📊 Module Usage Analytics

Track module adoption and usage:

| Module | Usage Count | Last Updated | Maturity |
|--------|-------------|--------------|----------|
| ResourceGroup | 100+ | 2024-06-01 | Stable |
| AzureNetwork | 85+ | 2024-06-15 | Stable |
| AzureCompute | 45+ | 2024-06-10 | Stable |
| AzureStorage | 60+ | 2024-06-05 | Stable |
| AzureKeyVault | 30+ | 2024-06-20 | Stable |
| AzureDatabase | 25+ | 2024-06-18 | Stable |

## 🔮 Roadmap

### Planned Enhancements

- **Container Modules**: AKS, Container Instances, Container Registry
- **AI/ML Modules**: Machine Learning, Cognitive Services
- **IoT Modules**: IoT Hub, Event Hubs, Stream Analytics
- **Integration Modules**: Logic Apps, Service Bus, API Management
- **DevOps Modules**: DevOps Projects, Pipelines, Artifacts

### Future Improvements

- Automated testing framework
- Module dependency management
- Performance optimization
- Enhanced security scanning
- Cross-cloud compatibility

This comprehensive module library provides the building blocks for creating consistent, secure, and well-documented Azure infrastructure through the Landing Zone implementation.
