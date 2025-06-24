# -
# - Private Endpoint
# -
resource "azurerm_private_endpoint" "az_private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.private_endpoint_tags

  # private_service_connection config block
  dynamic "private_service_connection" {
    for_each = var.private_service_connection
    content {
      name                           = lookup(private_service_connection.value, "name", null)
      private_connection_resource_id = lookup(private_service_connection.value, "private_connection_resource_id", null)
      is_manual_connection           = lookup(private_service_connection.value, "is_manual_connection", false)
      subresource_names              = lookup(private_service_connection.value, "subresource_names", null)
      request_message                = lookup(private_service_connection.value, "request_message", null)
    }
  }
}


