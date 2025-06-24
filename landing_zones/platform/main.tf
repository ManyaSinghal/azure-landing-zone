## Platform subscription RGs
module "platform_rgs" {
  source              = "../../Modules/ResourceGroup"
  for_each            = var.resource_groups
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  rg_tags             = each.value["rg_tags"]
}

