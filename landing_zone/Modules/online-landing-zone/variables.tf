variable "location" {
  description = "The Azure location where resources will be deployed"
  type        = string
}

variable "online_network_rg_name" {
  description = "The name of the Online landing zone network resource group"
  type        = string
}

variable "online_app_rg_name" {
  description = "The name of the Online landing zone application resource group"
  type        = string
}

variable "online_vnet_name" {
  description = "The name of the Online landing zone virtual network"
  type        = string
}

variable "online_vnet_address_space" {
  description = "The address space for the Online landing zone virtual network"
  type        = list(string)
}

variable "online_vnet_dns_servers" {
  description = "The DNS servers for the Online landing zone virtual network"
  type        = list(string)
}

variable "online_subnets" {
  description = "A map of subnet names to address prefixes for the Online landing zone"
  type        = map(list(string))
}

variable "resource_group_tags" {
  description = "Tags to apply to resource groups"
  type        = map(string)
  default = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

variable "vnet_tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
  default = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

variable "firewall_private_ip" {
  description = "The private IP address of the Azure Firewall in the hub network"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace for diagnostics"
  type        = string
}

variable "environment" {
  description = "The environment (dev, test, prod)"
  type        = string
  default     = "prod"
}

variable "sql_admin_username" {
  description = "The admin username for the SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "The admin password for the SQL Server"
  type        = string
  sensitive   = true
}