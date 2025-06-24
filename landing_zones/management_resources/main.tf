# Landing Zone Standard Policies

module "treyresearch" {
  source                        = "../../Modules/AzureMgmt/managementgroups"
  management_group_display_name = var.mg_name
}

module "treyresearch_mg" {
  source                        = "../../Modules/AzureMgmt/managementgroups"
  for_each                      = var.treyresearch_mg
  management_group_display_name = each.value["display_name"]
  parent_management_group_id    = module.treyresearch.management_group_id
  subscription_ids              = each.value["subscription_ids"]
}

module "landing_zones_mg" {
  source                        = "../../Modules/AzureMgmt/managementgroups"
  for_each                      = var.lz_mg
  management_group_display_name = each.value["display_name"]
  parent_management_group_id    = module.treyresearch_mg["${each.value["mg_key"]}"].management_group_id
  subscription_ids              = each.value["subscription_ids"]
  depends_on = [
    module.treyresearch_mg
  ]
}

module "policies" {
  source               = "../../Modules/AzureMgmt/Policies"
  for_each             = var.policies
  policy_name          = each.value["policy_name"]
  policy_display_name  = each.value["policy_display_name"]
  policy_definition_id = each.value["policy_definition_id"]
  policy_resource_id   = module.treyresearch.management_group_id
  policy_parameters = (
    can(jsondecode(each.value["policy_parameters"])) && each.value["policy_parameters"] != null
    ? jsondecode(each.value["policy_parameters"])
    : each.value["policy_parameters"]
  )
  location = lookup(each.value, "location", null)
}