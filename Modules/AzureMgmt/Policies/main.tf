
#Policies
resource "azurerm_management_group_policy_assignment" "allowed_regions" {
  name                 = var.policy_name
  display_name         = var.policy_display_name
  management_group_id  = var.management_group_id
  policy_definition_id = var.policy_definition_id
  parameters           = var.policy_parameters != null ? jsonencode(var.policy_parameters) : null
  location             = var.location != null ? var.location : "global"
  identity { type = "SystemAssigned" }
}
