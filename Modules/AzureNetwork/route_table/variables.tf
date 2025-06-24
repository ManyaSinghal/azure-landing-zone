
## route table common vars

variable "route_table_name" {
  description = "(Required) route table name"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) Map of the resource groups to create"
  type        = string
  default     = ""
}

variable "location" {
  description = "location of the resource"
  type        = string
  default     = ""
}

variable "disable_bgp_route_propagation" {
  description = "propagation of routes learned by BGP on that route table"
  type        = bool
  default     = true
}

variable "route_table_tags" {
  description = "tags of the resource"
  type        = map(string)
  default     = {}
}


# route vars
variable "routes" {
  description = "The route tables with their properties."
  type        = any
}


## route table filter common vars
variable "create_route_filter" {
  type    = bool
  default = false
}

variable "route_filter_name" {
  type    = string
  default = ""
}

# rule vars
variable "rules" {
  type    = list(map(string))
  default = []
}