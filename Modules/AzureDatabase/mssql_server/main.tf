resource "azurerm_mssql_server" "az_mssql_server" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.server_version
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password

  identity {
    type = var.identity_type
  }

  minimum_tls_version                  = var.minimum_tls_version
  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  tags = var.mssql_server_tags
}


