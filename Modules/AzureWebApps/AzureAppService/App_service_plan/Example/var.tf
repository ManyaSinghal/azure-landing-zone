variable "app_service_plan_tags" {
  type        = map(any)
  description = "The tags to apply to the created resources."
  default     = {}
}

variable "app_service_plan_name" {
  type        = string
  description = "The name prefix for all the resource of app service"
  default     = ""
}

# - App service plan variables
variable "app_service_plan_kind" {
  type        = string
  description = "The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan). Defaults to Windows. Changing this forces a new resource to be created."
  default     = "app"
}

variable "app_service_plan_sku" {
  type        = map(string)
  description = "sku supports the following:"
  default     = {}
}
