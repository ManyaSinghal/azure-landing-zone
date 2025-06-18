variable "resource_group_name" {
  type    = string
  default = "networking_rg"
}

variable "location" {
  type    = string
  default = "northcentralus"
}

variable "landingzone_vnet_name" {
  type        = string
  description = "The name of the Virtual Network"
}

variable "landingzone_vnet_address_space" {
  type        = list(string)
  description = "The address space prefix for the virtual network in CIDR format"
  default     = ["10.0.0.0/16"]
}

variable "landingzone_vnet_dns_servers" {
  type        = list(string)
  description = "List of DNS Servers for the virtual network"
}

variable "landingzone_vnet_tags" {
  type        = map(string)
  description = "The tags for the wan hub."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "landingzone_subnets" {
  type = map(any)

  default = {
    GatewaySubnet = ["10.0.250.0/24"]
  }
}

variable "landingzone_NSG_Prefix" {
  type        = string
  description = "The prefix used for network security groups"
  default     = "NSG"
}