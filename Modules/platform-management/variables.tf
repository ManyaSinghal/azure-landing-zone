variable "location" {
  description = "The location in Azure where resources will be created"
  type        = string
}

variable "platform_management_rg_name" {
  description = "The name of the resource group for platform management components"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "The number of days to retain data in Log Analytics"
  type        = number
  default     = 30
}

variable "automation_account_name" {
  description = "The name of the Azure Automation account"
  type        = string
}

variable "sentinel_enabled" {
  description = "Whether to enable Microsoft Sentinel on the Log Analytics workspace"
  type        = bool
  default     = false
}