variable "deploy_spoke_peering" {
  description = "Whether to deploy peering between hub and spoke networks"
  type        = bool
  default     = true
}

variable "deploy_online_peering" {
  description = "Whether to deploy peering between hub and online networks"
  type        = bool
  default     = true
}

variable "hub_vnet_name" {
  description = "The name of the hub virtual network"
  type        = string
}

variable "hub_vnet_id" {
  description = "The ID of the hub virtual network"
  type        = string
}

variable "hub_resource_group_name" {
  description = "The name of the hub resource group"
  type        = string
}

variable "spoke_vnet_name" {
  description = "The name of the spoke virtual network"
  type        = string
  default     = ""
}

variable "spoke_vnet_id" {
  description = "The ID of the spoke virtual network"
  type        = string
  default     = ""
}

variable "spoke_resource_group_name" {
  description = "The name of the spoke resource group"
  type        = string
  default     = ""
}

variable "use_hub_gateway" {
  type    = bool
  default = false
}