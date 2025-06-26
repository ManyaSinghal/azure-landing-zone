variable "db_name" {
  description = "The name of the MSSQL database."
  type        = string
}

variable "server_id" {
  description = "The ID of the SQL server."
  type        = string
}

variable "sku_name" {
  description = "The SKU for the SQL database, e.g., S0, P1, GP_S_Gen5_2."
  type        = string
}

variable "collation" {
  description = "The collation for the database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "The license type: LicenseIncluded or BasePrice."
  type        = string
  default     = null
}

variable "max_size_gb" {
  description = "The max size in GB."
  type        = number
  default     = 5
}

variable "read_scale" {
  description = "Whether read scale is enabled."
  type        = string
  default     = true
}

variable "zone_redundant" {
  description = "Whether zone redundancy is enabled."
  type        = bool
  default     = false
}

variable "enclave_type" {
  description = "Enclave type, e.g., VBS."
  type        = string
  default     = null
}

variable "ledger_enabled" {
  type    = bool
  default = false
}

variable "storage_account_type" {
  type    = string
  default = "Geo"
}

variable "auto_pause_delay_in_minutes" {
  type    = number
  default = null
}

variable "min_capacity" {
  type    = number
  default = null
}

variable "short_term_retention_days" {
  description = "Short-term retention in days."
  type        = number
  default     = null
}

variable "elastic_pool_id" {
  description = "Elastic pool ID if the database is to be added to a pool."
  type        = string
  default     = null
}

variable "audit_storage_endpoint" {
  type    = string
  default = null
}

variable "audit_storage_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "audit_retention_days" {
  type    = number
  default = 90
}

variable "enable_auditing" {
  type    = bool
  default = false
}

variable "mssql_db_tags" {
  type    = map(string)
  default = {}
}
