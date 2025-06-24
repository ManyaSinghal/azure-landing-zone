# resource group common vars
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure Region"
  default     = ""
}

variable "rg_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
