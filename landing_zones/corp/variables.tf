
#Global Variables


## Platform variables
variable "resource_groups" {}

## Platform Network variables
variable "corp_virtual_network" {}
variable "corp_subnets" {}
variable "corp_nsg" {}
variable "route_table_name" {}

## Variables for Corp Vms
variable "corp_nics" {}
variable "corp_vms" {}
variable "admin_username" {}
variable "admin_password" {}


# Platform Management variables
variable "platform_management_rg_name" {}
variable "log_analytics_workspace_name" {}


# Platform Connectivity variables
variable "platform_connectivity_rg_name" {}
variable "platform_vnet_name" {}
variable "platform_azure_firewall_name" {}


# New variables for multiple subscription support
variable "platform_subscription_id" {}
variable "corp_subscription_id" {}

# VNet Peering variables
variable "deploy_vnet_peering" {}

