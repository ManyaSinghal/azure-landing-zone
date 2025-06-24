
## route table common vars

variable "route_table_name" {
  description = "(Required) route table name"
  type        = string
  default     = ""
}

variable "disable_bgp_route_propagation" {
  description = "propagation of routes learned by BGP on that route table"
  type        = bool
  default     = true
}

variable "tags" {
  description = "tags of the resource"
  type        = map(string)
  default     = {}
}


# route vars

variable "routes" {
  description = "The route tables with their properties."
  type        = list(map(string))
  default     = []
}

## route table filter common vars

variable "create_route_filter" {
  type    = bool
  default = false
}

