## MSSQL server common vars
variable "msssql_server_name" {
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure"
  type        = string
  default     = ""
}

variable "mssql_server_version" {
  type        = string
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
}

variable "connection_policy" {
  type        = string
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default"
  default     = ""
}

variable "mssql_server_tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

# identity vars
variable "identity_type" {
  type        = string
  description = "Specifies the identity type of the Microsoft SQL Server. At this time the only allowed value is SystemAssigned"
  default     = null
}

## MSSQL firewall rule common vars
variable "firewall_rules" {
  type = map(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "List of Azure SQL Server firewall rule specification"
  default     = {}
}

## MSSQL virtual network rule common vars
variable "virtual_network_rule_name" {
  type        = string
  description = "The list of subnet names that the Azure SQL server will be connected to"
  default     = ""
}

variable "create_sql_virtual_network_rule" {
  type        = bool
  description = "The list of subnet names that the Azure SQL server will be connected to"
  default     = false
}

variable "allowed_subnet_names" {
  type        = list(string)
  description = "The list of subnet names that the Azure SQL server will be connected to"
}



## Secondary/Failover Azure SQL Server common vars
variable "enable_failover_server" {
  type        = bool
  description = "Whether or not enable_failover_server this server. Defaults to false"
  default     = false
}

variable "mssqlserver_secondary_server_name" {
  description = "The name of the seconday Microsoft SQL Server. This needs to be globally unique within Azure"
  type        = string
  default     = ""
}

variable "failover_location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "failover_resource_group_name" {
  description = "failover resource group name"
  type        = string
  default     = ""
}



## MSSQL Server Failover Group common vars
variable "failover_group_name" {
  description = "The name of the failover group"
  type        = string
  default     = ""
}

variable "failover_database_list" {
  description = " A list of database ids to add to the failover group"
  type        = list(string)
  default     = []
}


## MSSQL server extended auditing policy common vars
variable "create_mssql_server_extended_auditing_policy" {
  type        = bool
  description = "Whether or not server_extended_auditing_policy is created for this server. Defaults to false"
  default     = false
}


## MSSQL server security alert policy common vars
variable "create_mssql_server_security_alert_policy" {
  type        = bool
  description = "Whether or not server_security_alert_policy is created for this server. Defaults to false"
  default     = false
}

variable "sc_policy_state" {
  type        = string
  description = "Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database server"
  default     = "Disabled"
}


## MSSQL server vulnerability assessment common vars
variable "create_mssql_server_vulnerability_assessment" {
  type        = bool
  description = "Whether or not server_security_alert_policy is created for this server. Defaults to false"
  default     = false
}

