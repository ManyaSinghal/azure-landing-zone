resource "azurerm_resource_group" "additional_rgs" {
  for_each = var.additional_resource_groups
  name     = each.key
  location = each.value
}