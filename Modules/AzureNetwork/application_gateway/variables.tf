# application gatway common vars
variable "application_gateway_name" {
  description = "Application Gateway name."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "firewall_policy_id" {
  description = "The ID of the Web Application Firewall Policy"
  type        = string
}
variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs"
  type        = list(string)
  default     = [] #["1", "2", "3"]
}

variable "enable_http2" {
  description = "Whether to enable http2 or not"
  type        = bool
  default     = true
}

variable "app_gateway_tags" {
  description = "Application Gateway tags."
  type        = map(string)
  default     = {}
}

# Backend address pool config vars
variable "backend_address_pool" {
  description = "List of maps including backend pool configurations"
  type        = any
  default     = {}
}

# Backend http setttings config vars
variable "backend_http_settings" {
  description = "List of maps including backend http settings configurations"
  type        = any
  default     = {}
}

# Frontend ip configurations config vars
variable "frontend_ip_configuration" {
  description = "frontend_ip_configuration for application gateway"
  type        = any
  default     = {}
}

# Frontend port config 
variable "frontend_port" {
  description = "Frontend port settings. Each port setting contains the name and the port for the frontend port."
  type        = any
}

# Gateway ip configuration vars
variable "gateway_ip_configurations" {
  description = "application gateway subnet details"
  type        = any
  default     = {}
}

# HTTP listener config vars
variable "http_listener" {
  description = "List of maps including http listeners configurations"
  type        = any
  default     = {}
}

# Identity config vars
variable "user_assigned_identity_id" {
  description = "User assigned identity id assigned to this resource"
  type        = map(string)
  default     = {}
}

# Request routing rule config vars
variable "request_routing_rule" {
  description = "List of maps including request routing rules configurations"
  type        = any
  default     = {}
}

# sku config vars
variable "sku" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_v2 and WAF_v2."
  type        = any
  default     = {}
}

# Trusted root certificate config vars
variable "trusted_root_certificate_configs" {
  description = "List of trusted root certificates. The needed values for each trusted root certificates are 'name' and 'data'."
  type        = any
  default     = {}
}

# ssl policy config vars
variable "ssl_policy" {
  description = "Application Gateway SSL configuration. The list of available policies can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview#predefined-ssl-policy"
  type        = any
  default     = {}
}

# Probe config vars
variable "probe" {
  description = "List of maps including request probes configurations"
  type        = any
  default     = {}
}

# SSL certificate config vars
variable "ssl_certificate" {
  description = "List of maps including ssl certificates configurations"
  type        = any
  default     = {}
}

# URL path map config vars
variable "url_path_map" {
  description = "List of maps including url path map configurations"
  type        = any
  default     = {}
}

# waf config vars
variable "enable_waf" {
  description = "Boolean to enable WAF."
  type        = any
  default = false
}

variable "file_upload_limit_mb" {
  description = " The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB."
  type        = number
  default     = 100
}

variable "waf_mode" {
  description = "The Web Application Firewall Mode. Possible values are Detection and Prevention."
  type        = string
  default     = "Prevention"
}

variable "max_request_body_size_kb" {
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB."
  type        = number
  default     = 128
}

variable "request_body_check" {
  description = "Is Request Body Inspection enabled?"
  type        = bool
  default     = true
}

variable "rule_set_type" {
  description = "The Type of the Rule Set used for this Web Application Firewall."
  type        = string
  default     = "OWASP"
}

variable "rule_set_version" {
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1."
  type        = number
  default     = 3.1
}

variable "disabled_rule_group_settings" {
  description = "The rule group where specific rules should be disabled. Accepted values can be found here: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#rule_group_name"
  type = list(object({
    rule_group_name = string
    rules           = list(string)
  }))
  default = []
}

variable "waf_exclusion_settings" {
  description = "WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#match_variable"
  type        = any
  default     = {}
}


# custom_error_configuration vars
variable "custom_error_configuration" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = {}
}

# autoscale_configuration vars
variable "autoscale_configuration" {
  description = "A autoscale_configuration block"
  type        = map(string)
  default     = {}
}

# Redirect configuration vars
variable "redirect_configuration" {
  description = "List of maps including redirect configurations"
  type        = any
  default     = {}
}

# Rewrite rule set config vars
variable "appgw_rewrite_rule_set" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = {}
}

## log analytics vars
variable "enable_diagnostic_setting" {
  description = "condition whether to enable diagnostic setting for resoruce"
  type        = bool
}

variable "logs_destinations_ids" {
  type    = list(string)
  default = []
}