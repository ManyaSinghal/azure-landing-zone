
#Global Variables

variable "location" {
  type        = string
  description = "The unique lowercase alpha numeric identifier for resources for the project."
}

variable "platform_management_rg_name" {
  description = "The name of the resource group for platform management components"
  type        = string
  default     = "TreyResearch-mgmt"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
  default     = "log-treyresearch-prod-001"
}

# Platform Connectivity variables
variable "platform_connectivity_rg_name" {
  description = "The name of the resource group for platform connectivity components"
  type        = string
  default     = "TreyResearch-Connectivity"
}

variable "platform_vnet_name" {
  description = "The name of the platform virtual network"
  type        = string
  default     = "vnet-platform-prod-01"
}

variable "landingzone_vnet_tags" {
  type        = map(string)
  description = "The tags for the wan hub."
}

variable "azure_firewall_name" {
  description = "The name of the Azure Firewall"
  type        = string
  default     = "fw-platform-prod-01"
}


# New variables for multiple subscription support

variable "platform_subscription_id" {
  description = "The subscription ID for the platform resources"
  type        = string
  default     = "3e96e598-99b1-4f61-8b48-8a66790f3cd0" # Replace with your actual platform subscription ID
}

# Variables for Online Landing Zone

variable "online_vnet_name" {
  description = "The name of the Online landing zone virtual network"
  type        = string
  default     = "vnet-online-prod-01"
}

variable "online_vnet_address_space" {
  description = "The address space for the Online landing zone virtual network"
  type        = list(string)
  default     = ["10.30.0.0/16"]
}

variable "online_vnet_dns_servers" {
  description = "The DNS servers for the Online landing zone virtual network"
  type        = list(string)
  default     = ["10.0.2.4", "10.0.2.5"] # Domain controllers in platform subnet
}

variable "online_network_rg_name" {
  description = "The name of the Online landing zone network resource group"
  type        = string
  default     = "rg-online-network"
}

variable "online_app_rg_name" {
  description = "The name of the Online landing zone application resource group"
  type        = string
  default     = "rg-online-app"
}

variable "online_subnets" {
  description = "A map of subnet names to address prefixes for the Online landing zone"
  type        = map(list(string))
  default = {
    "snet-online-web"  = ["10.30.1.0/24"]
    "snet-online-app"  = ["10.30.2.0/24"]
    "snet-online-data" = ["10.30.3.0/24"]
    "GatewaySubnet"    = ["10.30.0.0/27"]
    "AppGatewaySubnet" = ["10.30.0.64/27"]
  }
}

# VNet Peering variables
variable "deploy_vnet_peering" {
  description = "Whether to deploy VNet peering between hub and spokes"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment name (dev, test, prod) for resource naming"
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
  default     = "P@ssw0rd123!" # In production, use Azure Key Vault
  sensitive   = true
}


