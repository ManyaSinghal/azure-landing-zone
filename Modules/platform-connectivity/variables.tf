variable "location" {
  description = "The location in Azure where resources will be created"
  type        = string
}

variable "platform_connectivity_rg_name" {
  description = "The name of the resource group for platform connectivity components"
  type        = string
}

variable "platform_vnet_name" {
  description = "The name of the platform virtual network"
  type        = string
}

variable "platform_vnet_address_space" {
  description = "The address space for the platform virtual network"
  type        = list(string)
}

variable "platform_vnet_dns_servers" {
  description = "The DNS servers for the platform virtual network"
  type        = list(string)
  default     = []
}

variable "platform_vnet_tags" {
  description = "Tags to apply to the platform virtual network"
  type        = map(string)
  default     = {}
}

variable "platform_subnets" {
  description = "A map of subnet names to address prefixes"
  type        = map(list(string))
}

variable "deploy_azure_firewall" {
  description = "Whether to deploy Azure Firewall"
  type        = bool
  default     = false
}

variable "azure_firewall_name" {
  description = "The name of the Azure Firewall"
  type        = string
  default     = ""
}

variable "azure_firewall_sku_tier" {
  description = "The SKU tier of the Azure Firewall"
  type        = string
  default     = "Standard"
}

variable "azure_firewall_sku_name" {
  description = "The SKU name of the Azure Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "azure_firewall_tags" {
  description = "Tags to apply to the Azure Firewall"
  type        = map(string)
  default     = {}
}

variable "deploy_vnet_peering" {
  description = "Whether to deploy VNet peering between hub and spoke networks"
  type        = bool
  default     = false
}

variable "spoke_vnet_ids" {
  description = "A list of spoke VNet IDs to peer with the hub VNet"
  type        = list(string)
  default     = []
}