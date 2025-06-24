
#Policies
resource "azurerm_resource_policy_assignment" "allowed_regions" {
  name                 = var.policy_name
  display_name         = var.policy_display_name
  resource_id          = var.policy_resource_id
  policy_definition_id = var.policy_definition_id
  parameters           = var.policy_parameters != null ? jsonencode(var.policy_parameters) : null
  location             = var.location != null ? var.location : "global"
  identity { type = "SystemAssigned" }
}
