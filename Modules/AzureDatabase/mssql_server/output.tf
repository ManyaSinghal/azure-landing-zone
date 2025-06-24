## MSSQL server outputs

output "az_mssql_server_id" {
  description = "The ID of the Microsoft SQL Server"
  value       = azurerm_mssql_server.az_mssql_server.id
}

output "az_mssql_server_name" {
  description = "The ID of the Microsoft SQL Server"
  value       = azurerm_mssql_server.az_mssql_server.name
}

output "az_mssql_server_administrator_login" {
  description = "The server's administrator login name"
  value       = azurerm_mssql_server.az_mssql_server.administrator_login
}

output "az_mssql_server_fully_qualified_domain_name" {
  description = "The fully qualified domain name of the Azure SQL Server"
  value       = azurerm_mssql_server.az_mssql_server.fully_qualified_domain_name
}

output "az_mssql_server_restorable_dropped_database_ids" {
  description = "A list of dropped restorable database IDs on the server"
  value       = azurerm_mssql_server.az_mssql_server.restorable_dropped_database_ids
}
