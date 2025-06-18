variable "gtwy_subnet_object" {
  type = object({
    # Declare an object using only the subset of attributes the module
    # needs. Terraform will allow any object that has at least these
    # attributes.
    id                  = string
    resource_group_name = string
  })
}

variable "expressroute_circuit_name" {
  type    = string
  default = "expressRoute1"
}
variable "expressroute_circuit_tags" {
  type        = map(string)
  description = "The tags for the expressroute circuit."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "expressroute_circuit_service_provider" {
  type = string
}

variable "expressroute_circuit_peering_location" {
  type = string
}

variable "expressroute_circuit_bandwidth" {
  type    = number
  default = 50
}

variable "expressroute_circuit_sku" {
  type    = string
  default = "Standard"
}

variable "expressroute_circuit_family" {
  type    = string
  default = "MeteredData"
}

variable "expressroute_gtwy_pub_ip_name" {
  type    = string
  default = "ExpressRoute_Gateway_Pub_IP"
}

variable "expressroute_vpn_gtwy_name" {
  type    = string
  default = "VPN_Gateway"
}

variable "expressroute_gtwy_vpn_tags" {
  type        = map(string)
  description = "The tags for the expressroute vpn gateway."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "expressroute_gtwy_vpn_type" {
  type    = string
  default = "RouteBased"
}

variable "expressroute_gtwy_vpn_active_active" {
  type    = bool
  default = false
}

variable "expressroute_gtwy_vpn_enable_bgp" {
  type    = bool
  default = false
}

variable "expressroute_gtwy_vpn_sku" {
  type    = string
  default = "Standard"
}

variable "expressroute_gtwy_pub_ip_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}