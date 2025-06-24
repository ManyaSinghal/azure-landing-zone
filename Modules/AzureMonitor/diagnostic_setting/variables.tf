## monitor diagnostic setting common vars

variable "diagnostic_setting_name" {
  description = "Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "target_resource_id" {
  description = "The ID of an existing Resource on which to configure Diagnostic Settings"
  type        = string
  default     = ""
}

variable "eventhub_name" {
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent"
  type        = string
  default     = null
}

variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set."
  default     = []
}

variable "log_analytics_id" {

}

variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. Azure Data Factory is the only compatible resource so far."
}

# metric config vars
variable "metric" {
  description = "resource metric block"
  type        = any
  default     = {}
}

# log config vars
variable "log" {
  description = "resource metric block"
  type        = any
  default     = {}
}