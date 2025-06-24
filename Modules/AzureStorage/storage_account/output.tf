## storage account outputs

output "az_storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.az_storage_account.id
}

output "az_storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.az_storage_account.name
}

output "az_storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = azurerm_storage_account.az_storage_account.primary_location
}

output "az_storage_account_secondary_location" {
  description = "The secondary location of the storage account"
  value       = azurerm_storage_account.az_storage_account.secondary_location
}

output "az_storage_account_primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location."
  value       = azurerm_storage_account.az_storage_account.primary_web_endpoint
}

output "az_storage_account_primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = azurerm_storage_account.az_storage_account.primary_web_host
}

output "az_storage_primary_connection_string" {
  description = "The primary connection string for the storage account."
  value       = azurerm_storage_account.az_storage_account.primary_connection_string
  sensitive   = true
}
# Storage account outputs


output "az_storage_account_kind" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.az_storage_account.account_kind
}

output "az_storage_account_account_tier" {
  value = azurerm_storage_account.az_storage_account.account_tier
}

output "az_storage_account_replication_type" {
  value = azurerm_storage_account.az_storage_account.account_replication_type
}




output "az_storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_blob_endpoint
}

output "az_storage_account_primary_queue_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_queue_endpoint
}

output "az_storage_account_primary_table_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_table_endpoint
}

output "az_storage_account_primary_file_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_file_endpoint
}

output "az_storage_account_primary_access_key" {
  value = azurerm_storage_account.az_storage_account.primary_access_key
}

output "az_storage_account_secondary_access_key" {
  value = azurerm_storage_account.az_storage_account.secondary_access_key
}

output "az_storage_account_primary_connection_string" {
  value = azurerm_storage_account.az_storage_account.primary_connection_string
}

output "az_storage_account_primary_blob_string" {
  value = azurerm_storage_account.az_storage_account.primary_blob_connection_string
}

