## Private Endpoint common vars
variable "private_endpoint_name" {
  type        = string
  description = "Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group"
  default     = ""
}

variable "location" {
  type        = string
  description = "The supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint"
  default     = ""
}

variable "private_endpoint_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# private_service_connection vars
variable "private_service_connection" {
  type        = map(any)
  description = "private_service_connection"
  default     = {}
}

