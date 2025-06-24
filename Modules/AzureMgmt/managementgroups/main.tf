resource "azurerm_management_group" "management_group" {
  name                       = replace(var.management_group_display_name, " ", "_")
  display_name               = var.management_group_display_name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = var.subscription_ids
}

data "azuread_user" "owner_user" {
  for_each            = toset(var.management_group_users_for_owner_role)
  user_principal_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "owner_role_assignment_for_user" {
  for_each             = data.azuread_user.owner_user
  scope                = azurerm_management_group.management_group.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.owner_user[each.key].object_id
}

data "azuread_user" "reader_user" {
  for_each            = toset(var.management_group_users_for_reader_role)
  user_principal_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "reader_role_assignment_for_user" {
  for_each             = data.azuread_user.reader_user
  scope                = azurerm_management_group.management_group.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.reader_user[each.key].object_id
}

data "azuread_group" "owner_usergroup" {
  for_each     = toset(var.management_group_usergroups_for_owner_role)
  display_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "owner_role_assignment_for_usergroup" {
  for_each             = data.azuread_group.owner_usergroup
  scope                = azurerm_management_group.management_group.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_group.owner_usergroup[each.key].object_id
}

data "azuread_group" "reader_usergroup" {
  for_each     = toset(var.management_group_usergroups_for_reader_role)
  display_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "reader_role_assignment_for_usergroup" {
  for_each             = data.azuread_group.reader_usergroup
  scope                = azurerm_management_group.management_group.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.reader_usergroup[each.key].object_id
}

