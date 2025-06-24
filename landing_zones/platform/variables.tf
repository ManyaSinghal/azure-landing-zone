## Platform variables
variable "resource_groups" {}

## Management Variables
variable "log_analytics_workspace" {}
variable "automation_account_name" {}
variable "platform_subscription_id" {}


## Platform Network variables
variable "platform_virtual_network" {}
variable "platform_subnets" {}
variable "platform_nsg" {}
variable "azure_firewall_name" {}
variable "route_table_name" {}
variable "expressroute_circuit_name" {}
variable "vnet_gws" {}

## Variables for Domain controller
variable "dc_sa_name" {}
variable "dc_kv_name" {}
variable "dc_nics" {}
variable "dc_vms" {}
variable "admin_username" {}
variable "admin_password" {}