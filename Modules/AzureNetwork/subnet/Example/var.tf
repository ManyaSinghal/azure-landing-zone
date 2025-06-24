## Subnet common vars
variable "subnet_name" {
  description = "name of the azure subnet"
  type        = string
  default     = ""
}


variable "tags" {
  description = "tags of the resource"
  type        = map(string)
  default     = {}
}

variable "subnet_address_prefix" {
  description = "The address prefix list to use for the subnet"
  type        = list(string)
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet"
  type        = list(string)
  default     = []
}

# subnet delegation vars
variable "subnet_delegation" {
  description = <<EOD
Configuration delegations on subnet
object({
  name = object({
    name = string,
    actions = list(string)
  })
})
EOD
  type        = map(list(any))
  default     = {}
}

variable "create_subnet_nsg_association" {
  description = "condition to create subnet nsg association"
  type        = bool
  default     = false
}

