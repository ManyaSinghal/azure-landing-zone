resource "azurerm_management_group" "mainmanagement_group" {
  name         = replace(var.mainmanagement_group1_display_name, " ", "_")
  display_name = var.mainmanagement_group1_display_name

}

resource "azurerm_management_group" "management_group1" {

  display_name               = var.management_group1_display_name
  parent_management_group_id = azurerm_management_group.mainmanagement_group.id

  subscription_ids = var.management_group1_subscription_ids
}


resource "azurerm_management_group" "management_group2" {

  count = length(var.management_group2_display_name) > 0 ? 1 : 0

  display_name = var.management_group2_display_name

  parent_management_group_id = azurerm_management_group.mainmanagement_group.id

  subscription_ids = var.management_group2_subscription_ids
}

resource "azurerm_management_group" "management_group2a" {

  count = length(var.management_group2a_display_name) > 0 ? 1 : 0

  display_name = var.management_group2a_display_name

  parent_management_group_id = azurerm_management_group.management_group2[0].id

  subscription_ids = var.management_group2a_subscription_ids
}

resource "azurerm_management_group" "management_group2b" {

  count = length(var.management_group2b_display_name) > 0 ? 1 : 0

  display_name = var.management_group2b_display_name

  parent_management_group_id = azurerm_management_group.management_group2[0].id

  subscription_ids = var.management_group2b_subscription_ids
}


resource "azurerm_management_group" "management_group3" {

  count = length(var.management_group3_display_name) > 0 ? 1 : 0

  display_name = var.management_group3_display_name

  parent_management_group_id = azurerm_management_group.mainmanagement_group.id

  subscription_ids = var.management_group3_subscription_ids
}

resource "azurerm_management_group" "management_group4" {

  count = length(var.management_group4_display_name) > 0 ? 1 : 0

  display_name = var.management_group4_display_name

  parent_management_group_id = azurerm_management_group.mainmanagement_group.id

  subscription_ids = var.management_group4_subscription_ids
}


data "azuread_user" "owner_user" {
  for_each            = toset(var.mainmanagement_group_users_for_owner_role)
  user_principal_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "owner_role_assignment_for_user" {
  for_each             = data.azuread_user.owner_user
  scope                = azurerm_management_group.mainmanagement_group.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.owner_user[each.key].object_id
}

data "azuread_user" "reader_user" {
  for_each            = toset(var.mainmanagement_group_users_for_reader_role)
  user_principal_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "reader_role_assignment_for_user" {
  for_each             = data.azuread_user.reader_user
  scope                = azurerm_management_group.mainmanagement_group.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.reader_user[each.key].object_id
}

data "azuread_group" "owner_usergroup" {
  for_each     = toset(var.mainmanagement_group_usergroups_for_owner_role)
  display_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "owner_role_assignment_for_usergroup" {
  for_each             = data.azuread_group.owner_usergroup
  scope                = azurerm_management_group.mainmanagement_group.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_group.owner_usergroup[each.key].object_id
}

data "azuread_group" "reader_usergroup" {
  for_each     = toset(var.mainmanagement_group_usergroups_for_reader_role)
  display_name = format("%s", each.key)
}

resource "azurerm_role_assignment" "reader_role_assignment_for_usergroup" {
  for_each             = data.azuread_group.reader_usergroup
  scope                = azurerm_management_group.mainmanagement_group.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.reader_usergroup[each.key].object_id
}

