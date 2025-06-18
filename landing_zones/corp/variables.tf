
#Global Variables

variable "location" {
  type        = string
  description = "The unique lowercase alpha numeric identifier for resources for the project."
}

variable "admin_username" {
  type        = string
  description = "The username for the local admin account on the VMs"
}

variable "admin_password" {
  type        = string
  description = "The password for the local admin account on the VMs"
}

# Platform Management variables
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

# Variables for Corp Landing Zone

variable "corp_vnet_name" {
  description = "The name of the Corp landing zone virtual network"
  type        = string
  default     = "vnet-corp-prod-01"
}

variable "corp_vnet_address_space" {
  description = "The address space for the Corp landing zone virtual network"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "corp_vnet_dns_servers" {
  description = "The DNS servers for the Corp landing zone virtual network"
  type        = list(string)
  default     = ["10.0.2.4", "10.0.2.5"] # Domain controllers in platform subnet
}

variable "corp_network_rg_name" {
  description = "The name of the Corp landing zone network resource group"
  type        = string
  default     = "rg-corp-network"
}

variable "corp_app_rg_name" {
  description = "The name of the Corp landing zone application resource group"
  type        = string
  default     = "rg-corp-app"
}

variable "corp_subnets" {
  description = "A map of subnet names to address prefixes for the Corp landing zone"
  type        = map(list(string))
  default = {
    "snet-corp-vm"   = ["10.20.1.0/24"]
    "snet-corp-data" = ["10.20.2.0/24"]
    "GatewaySubnet"  = ["10.20.0.0/27"]
  }
}


# VNet Peering variables
variable "deploy_vnet_peering" {
  description = "Whether to deploy VNet peering between hub and spokes"
  type        = bool
  default     = true
}
variable "vm_count" {
  description = "The number of VMs to deploy in the Corp landing zone"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The size of the VMs to deploy in the Corp landing zone"
  type        = string
  default     = "Standard_B2s"
}
variable "environment" {
  description = "The environment name (dev, test, prod) for resource naming"
  type        = string
  default     = "prod"
}

