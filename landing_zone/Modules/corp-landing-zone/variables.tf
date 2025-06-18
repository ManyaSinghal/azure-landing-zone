# Corp Landing Zone VM Variables
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

# Online Landing Zone Variables
variable "environment" {
  description = "The environment (dev, test, prod)"
  type        = string
  default     = "prod"
}

variable "admin_username" {
  type        = string
  description = "The username for the local admin account on the VMs"
}

variable "admin_password" {
  type        = string
  description = "The password for the local admin account on the VMs"
}


# Corp and Online Landing Zone Variables
variable "deploy_corp_lz" {
  description = "Whether to deploy the Corp landing zone"
  type        = bool
  default     = false
}

variable "deploy_online_lz" {
  description = "Whether to deploy the Online landing zone"
  type        = bool
  default     = false
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

variable "corp_subnets" {
  description = "A map of subnet names to address prefixes for the Corp landing zone"
  type        = map(list(string))
  default = {
    "snet-corp-vm"   = ["10.20.1.0/24"]
    "snet-corp-data" = ["10.20.2.0/24"]
    "GatewaySubnet"  = ["10.20.0.0/27"]
  }
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

variable "deploy_vnet_peering" {
  description = "Whether to deploy VNet peering between hub and spokes"
  type        = bool
  default     = false
}

# Management Group variables for Corp and Online
variable "management_group2a_display_name" {
  description = "The display name of the Corp landing zone management group"
  type        = string
  default     = "Corp-LZ"
}

variable "management_group2a_subscription_ids" {
  description = "The subscription IDs to associate with the Corp landing zone management group"
  type        = list(string)
  default     = []
}

variable "management_group2b_display_name" {
  description = "The display name of the Online landing zone management group"
  type        = string
  default     = "Online-LZ"
}

variable "management_group2b_subscription_ids" {
  description = "The subscription IDs to associate with the Online landing zone management group"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "The Azure location where resources will be deployed"
  type        = string
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
