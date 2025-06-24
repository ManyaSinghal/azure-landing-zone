## Application Insights commom vars

variable "application_insights_name" {
  type        = string
  description = "Specifies the name of the Application Insights component. Changing this forces a new resource to be created"
  default     = ""
}

variable "location" {
  type        = string
  description = "azure location of Application Insights component"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Insights component."
  default     = ""
}
variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter"
  default     = ""
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90"
  default     = null
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "Specifies the Application Insights component daily data volume cap in GB"
  default     = null
}

variable "daily_data_cap_notifications_disabled" {
  type        = bool
  description = "pecifies if a notification email will be send when the daily data volume cap is met"
  default     = false
}

variable "sampling_percentage" {
  type        = number
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry"
  default     = null
}

variable "disable_ip_masking" {
  type        = bool
  description = "By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip. Defaults to false"
  default     = false
}

variable "application_insights_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "workspace_id" {

}