# General Resource variable

variable "app_service_plan_name" {
  type        = string
  description = "The name prefix for all the resource of app service"
  default     = ""
}

variable "location" {
  description = "The location of the resources."
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group that will contain the resources."
  default     = ""
}

variable "app_service_plan_kind" {
  type        = string
  description = "The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan). Defaults to Windows. Changing this forces a new resource to be created."
  default     = "app"
}

variable "maximum_elastic_worker_count" {
  type        = number
  description = "The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan."
}

variable "app_service_environment_id" {
  type        = string
  description = "App service Environment ID. If its created"
  default     = null
}

variable "app_service_plan_reserved" {
  type        = bool
  description = "Is this App Service Plan Reserved. Defaults to false."
  default     = false
}

variable "per_site_scaling" {
  type        = bool
  description = " Can Apps assigned to this App Service Plan be scaled independently? If set to false apps assigned to this plan will scale to all instances of the plan. Defaults to false."
  default     = false
}

variable "app_service_plan_tags" {
  type        = map(any)
  description = "The tags to apply to the created resources."
  default     = {}
}

# sku config vars
variable "app_service_plan_sku" {
  type        = map(string)
  description = "sku supports the following:"
  default     = {}
}