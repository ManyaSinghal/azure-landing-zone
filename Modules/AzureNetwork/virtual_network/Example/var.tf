
## virtual network common vars

variable "virtual_network_name" {
  description = "Name of your Azure Virtual Network"
  type        = string
  default     = ""
}

variable "vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

## ddos protection vars
variable "create_ddos_plan" {
  description = "Create an ddos plan - Default is false"
  type        = bool
  default     = false
}

variable "ddos_plan_name" {
  description = "The name of AzureNetwork DDoS Protection Plan"
  type        = string
  default     = ""

}

