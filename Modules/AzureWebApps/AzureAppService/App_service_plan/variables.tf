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

variable "maximum_elastic_worker_count" {
  type        = number
  description = "The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan."
}

variable "app_service_environment_id" {
  type        = string
  description = "App service Environment ID. If its created"
  default     = null
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
  type        = string
  description = "sku supports the following:"
  default     = "F1"
}

variable "os_type" {
  type        = string
  description = "The OS type of the App Service Plan. Possible values are Windows and Linux. Defaults to Windows."
  default     = "Windows"
}