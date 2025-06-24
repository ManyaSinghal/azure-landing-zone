variable "server_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "server_version" {
  type    = string
  default = "12.0"
}

variable "admin_login" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "outbound_network_restriction_enabled" {
  type    = bool
  default = false
}

variable "mssql_server_tags" {
  type    = map(string)
  default = {}
}
