variable "enable_log_analytics_workspace" {
  type        = bool
  description = "Specify whether want to create log analytics or not."
  default     = true
}

variable "prefix" {
  type        = string
  description = "prefix for the loga nanlytics workspace name"
  default     = ""
}

variable "log_analytics_workspace_sku" {
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). Defaults to PerGB2018."
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = string
  default     = 30
}

variable "log_solution_name" {
  description = "Specifies the name of the solution to be deployed."
  type        = string
  default     = ""
}

variable "plan" {
  description = "plan includes:The publisher of the solution, The product name of the solution, A promotion code to be used with the solution."
  type        = any
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}