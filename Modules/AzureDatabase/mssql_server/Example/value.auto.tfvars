
connection_policy             = "default"
enable_failover_server        = true
failover_location             = "westus2"
identity_type                 = "SystemAssigned"
public_network_access_enabled = true
mssql_server_tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}
create_sql_virtual_network_rule = true
firewall_rules = {
  "default" = {
    name             = "azuresql-firewall-rule-default"
    start_ip_address = "49.207.59.100"
    end_ip_address   = "49.207.59.100"
  }
}

create_mssql_server_extended_auditing_policy = true
create_mssql_server_security_alert_policy    = true
sc_policy_state                              = "Enabled"
create_mssql_server_vulnerability_assessment = true
allowed_subnet_names                         = null
msssql_server_name                           = "test-db-server"
mssql_server_version                         = "12.0"