## function app common vars

variable "app_service_name" {
  type        = string
  description = " Specifies the name of the  App."
  default     = null
}

variable "location" {
  description = "The location of the resources."
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group that will contain the resources."
  default     = null
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan within which to create this  App."
  default     = null
}

variable "app_settings" {
  type        = any
  description = "A map of key-value pairs for App Settings and custom values."
  default     = {}
}

variable "logs" {
  type        = any
  description = "A map of key-value pairs for logs."
  default     = {}
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Should the  App send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "enabled" {
  type        = bool
  description = "Is the  App enabled?"
  default     = true
}

variable "client_certificate_enabled" {
  type        = bool
  description = "Should the function app use Client Certificates."
  default     = true
}

variable "client_certificate_mode" {
  type        = string
  description = "The mode of the  App's client certificates requirement for incoming requests. Possible values are Required, Optional, and OptionalInteractiveUser."
  default     = null
}

variable "client_certificate_exclusion_paths" {
  type        = string
  description = "Paths to exclude when using client certificates, separated by ;"
  default     = null
}

variable "key_vault_reference_identity_id" {
  type        = string
  description = "The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the identity block."
  default     = null
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "The subnet id which will be used by this  App for regional virtual network integration."
  default     = null
}

variable "zip_deploy_file" {
  type        = string
  description = "The local path and filename of the Zip packaged application to deploy to this Linux  App."
  default     = null
}

variable "https_only" {
  type        = bool
  description = "Can the  App only be accessed via HTTPS? Defaults to false."
  default     = false
}

variable "app_service_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# identity config vars
variable "identity_type" {
  type        = string
  description = " Specifies the identity type of the  App. Possible values are SystemAssigned"
  default     = "SystemAssigned"
}

# connection_string config vars
variable "connection_string" {
  type = map(object({
    name  = string
    type  = string
    value = string
  }))
  description = "The type of the Connection String. Possible values are APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure and SQLServer, valueThe value for the Connection String."
  default     = {}
}

# string config vars
variable "site_config" {
  type        = any
  description = ""
  default     = {}
}

# cors config vars
variable "cors" {
  type = map(object({
    allowed_origins     = string
    support_credentials = string
  }))
  description = "allowed_origins - (Optional) A list of origins which should be able to make cross-origin calls. * can be used to allow all calls.support_credentials - (Optional) Are credentials supported?"
  default     = {}
}

# ip_restriction config vars
variable "ip_restriction" {
  type = list(object({
    ip_address                = string
    service_tag               = list(string)
    virtual_network_subnet_id = string
  }))
  description = "ip_address - (Optional) The IP Address used for this IP Restriction in CIDR notation.,service_tag - (Optional) The Service Tag used for this IP Restriction.,virtual_network_subnet_id - (Optional) The Virtual Network Subnet ID used for this IP"
  default     = []
}

# scm_ip_restriction config vars
variable "scm_ip_restriction" {
  type = list(object({
    ip_address                = string
    service_tag               = string
    virtual_network_subnet_id = string
    name                      = string
    priority                  = string
    action                    = string
  }))
  description = "ip_address - (Optional) The IP Address used for this IP Restriction in CIDR notation.,service_tag - (Optional) The Service Tag used for this IP Restriction.,virtual_network_subnet_id - (Optional) The Virtual Network Subnet ID used for this IP"
  default     = []
}

# source_control config vars
variable "source_control" {
  type        = map(string)
  description = "repo_urlThe URL of the source code repository.,branch - (Optional) The branch of the remote repository to use. Defaults to 'master'.,manual_integration - (Optional) Limits to manual integration. Defaults to false if not specified.,rollback_enabled - (Optional) Enable roll-back for the repository. Defaults to false if not specified.,use_mercurial - (Optional) Use Mercurial if true, otherwise uses Git."
  default     = {}
}

# auth_settings config vars
variable "auth_settings" {
  type        = any
  description = "authorization settings block of function app"
  default     = {}
}

variable "sticky_settings" {
  type        = any
  description = "sticky settings block of function app"
  default     = {}
}


variable "storage_account" {
  type        = any
  description = "storage_account settings block of function app"
  default     = {}
}

variable "backup" {
  type        = any
  description = "backup settings block of function app"
  default     = {}
}
