
#Global Variables


## online variables
variable "resource_groups" {}

## online Network variables
variable "online_virtual_network" {}
variable "online_subnets" {}
variable "online_nsg" {}
variable "route_table_name" {}

## Variables for online
variable "admin_username" {}
variable "admin_password" {}
variable "environment" {}

# Platform Management variables
variable "platform_management_rg_name" {}
variable "log_analytics_workspace_name" {}

# Platform Connectivity variables
variable "platform_connectivity_rg_name" {}
variable "platform_vnet_name" {}
variable "platform_azure_firewall_name" {}

# New variables for multiple subscription support
variable "platform_subscription_id" {}
variable "online_subscription_id" {}

# VNet Peering variables
variable "deploy_vnet_peering" {}
variable "key_vault_name" {}
variable "platform_identity_rg_name" {}