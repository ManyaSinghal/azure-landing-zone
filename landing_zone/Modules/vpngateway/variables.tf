variable "gtwy_subnet_object" {
  type = object({
    # Declare an object using only the subset of attributes the module
    # needs. Terraform will allow any object that has at least these
    # attributes.
    id                  = string
    resource_group_name = string
  })
}

variable "gtwy_pub_ip_name" {
  type    = string
  default = "VPN_Gateway_Pub_IP"
}

variable "gtwy_vpn_name" {
  type    = string
  default = "VPN_Gateway"
}

variable "deploy_local_network_gtwy_connection" {
  type        = bool
  description = "This is to deploy local network gateway and create virtual network gateway(site-to-site) connection."
}

variable "gtwy_vpn_tags" {
  type        = map(string)
  description = "The tags for the public ip."
  default = {
    CostCenter = "None"
    Enviroment = "Prod"

  }
}

variable "gtwy_local_name" {
  type    = string
  default = "OnPremise"
}

variable "gtwy_local_address" {
  type = string
}

variable "gtwy_local_address_spaces" {
  type = list(string)
}

variable "gtwy_local_tags" {
  type        = map(string)
  description = "The tags for the public ip."
  default = {
    CostCenter = "None"
    Enviroment = "Prod"

  }
}

variable "gtwy_connection_name" {
  type    = string
  default = "VPN_Connection"
}

variable "gtwy_connection_private_key" {
  type = string
}

variable "gtwy_vpn_type" {
  type    = string
  default = "RouteBased"
}

variable "gtwy_vpn_active_active" {
  type    = bool
  default = false
}

variable "gtwy_vpn_enable_bgp" {
  type    = bool
  default = false
}

variable "gtwy_vpn_sku" {
  type    = string
  default = "Basic"
}

variable "gtyw_vpn_generation" {
  type    = string
  default = "Generation1"
}