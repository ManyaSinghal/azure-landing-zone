variable "resource_group_name" {
  description = "Name of the resource group in which Firewall needs to be created"
}

variable "firewall_additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "subnet id where the Azure Firewall will be deployed"
  default     = ""
}
variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
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

variable "ip_config_name" {

}

variable "fw_network_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name                  = string
      description           = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      destination_addresses = list(string)
      protocols             = list(string)
    }))
  }))
  description = "The Azure Firewall Rules with their properties."
  default     = {}
}

variable "fw_nat_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    rules = list(object({
      name               = string
      description        = string
      source_addresses   = list(string)
      destination_ports  = list(string)
      protocols          = list(string)
      translated_address = string
      translated_port    = number
    }))
  }))
  description = "The Azure Firewall Nat Rules with their properties."
  default     = {}
}

variable "fw_application_rules" {
  type = map(object({
    name         = string
    firewall_key = string
    priority     = number
    action       = string
    rules = list(object({
      name             = string
      description      = string
      source_addresses = list(string)
      fqdn_tags        = list(string)
      target_fqdns     = list(string)
      protocol = list(object({
        port = number
        type = string
      }))
    }))
  }))
  description = "The Azure Firewall Application Rules with their properties."
  default     = {}
}
