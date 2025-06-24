variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the express route"
  type        = string
  default     = ""
}
variable "location" {
  type    = string
  default = ""
}

variable "vnet_gw_name" {
  type    = string
  default = "VPN_Gateway"
}

variable "vnet_gw_tags" {
  type        = map(string)
  description = "The tags for the public ip."
  default = {
    CostCenter = "None"
    Enviroment = "Prod"

  }
}

variable "local_gw_name" {
  type    = string
  default = "OnPremise"
}

variable "local_gw_address" {
  type = string
}

variable "create_local_nw_gw" {

}

variable "local_gw_address_spaces" {
  type = list(string)
}

variable "gw_connection_name" {
  type    = string
  default = "VPN_Connection"
}

variable "gw_connection_private_key" {
  type    = string
  default = ""
}

variable "vnet_gw_type" {
  type    = string
  default = "RouteBased"
}

variable "vnet_gw_active_active" {
  type    = bool
  default = false
}

variable "vnet_gw_enable_bgp" {
  type    = bool
  default = false
}

variable "vnet_gw_sku" {
  type    = string
  default = "Basic"
}

variable "vnet_gw_generation" {
  type    = string
  default = "Generation1"
}

variable "vnet_gw_snet_id" {

}