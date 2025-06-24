
# # OUTPUTS Azure Firewall

output "firewall_ids" {
  value = azurerm_firewall.az_firewall.id
}

output "firewall_names" {
  value = azurerm_firewall.az_firewall.name
}

output "firewall_private_ips" {
  value = azurerm_firewall.az_firewall.ip_configuration[0].private_ip_address
}

