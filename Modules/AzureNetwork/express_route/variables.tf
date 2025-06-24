variable "location" {
  description = "The location where the express route should exist. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the express route"
  type        = string
  default     = ""
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