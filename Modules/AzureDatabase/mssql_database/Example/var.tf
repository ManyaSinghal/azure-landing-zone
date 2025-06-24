
## MSSQL database common vars

variable "mssql_database_name" {
  description = "The name of the Ms SQL Database. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "create_mode" {
  type        = string
  description = "The create mode of the database"
  default     = null
}

variable "collation" {
  type        = string
  description = "Specifies the collation of the database. Changing this forces a new resource to be created"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  type        = string
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice"
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes"
  default     = null
}

variable "sku_name" {
  description = "Specifies the name of the sku used by the database"
  type        = string
  default     = null
}

variable "mssql_db_tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

