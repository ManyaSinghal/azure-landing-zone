## virtual network peering Source vars

variable "virtual_network_src_rg_name" {
  type        = string
  description = "virtual_network source resource group name"
}

variable "virtual_network_src_name" {
  type        = string
  description = "virtual_network source name"
}
variable "virtual_network_src_id" {
  description = "ID of the src vnet to peer"
  type        = string
}

variable "allow_virtual_src_network_access" {
  description = "Option allow_virtual_network_access for the src vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}

variable "allow_forwarded_src_traffic" {
  description = "Option allow_forwarded_traffic for the src vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}

variable "allow_gateway_src_transit" {
  description = "Option allow_gateway_transit for the src vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "use_remote_src_gateway" {
  description = "Option use_remote_gateway for the src vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}


## virtual network peering destination vars

variable "virtual_network_dest_rg_name" {
  type        = string
  description = "virtual_network destination resource group name"
}
variable "virtual_network_dest_name" {
  type        = string
  description = "virtual_network destination name"
}
variable "virtual_network_dest_id" {
  description = "ID of the dest vnet to peer"
  type        = string
}
variable "allow_virtual_dest_network_access" {
  description = "Option allow_virtual_network_access for the dest vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}
variable "allow_forwarded_dest_traffic" {
  description = "Option allow_forwarded_traffic for the dest vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}
variable "allow_gateway_dest_transit" {
  description = "Option allow_gateway_transit for the dest vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}
variable "use_remote_dest_gateway" {
  description = "Option use_remote_gateway for the dest vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}