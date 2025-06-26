# # General

variable "policy_name" {}
variable "policy_display_name" {}
variable "management_group_id" {}
variable "policy_definition_id" {}
variable "policy_parameters" {
  type = any
}
variable "location" {
  type        = string
  description = "Region name."
}
