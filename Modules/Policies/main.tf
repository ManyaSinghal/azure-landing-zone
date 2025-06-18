data "azurerm_management_group" "main_management_group" {
  name = replace(var.mainmanagement_group1_display_name, " ", "_")
}

#Policies

#https://github.com/Azure/azure-policy/blob/master/samples/built-in-policy/allowed-locations/

resource "azurerm_resource_policy_assignment" "allowed_regions" {
  name                 = "allowed_regions"
  display_name         = "Allowed Azure Region for Resources and Resource Groups"
  count                = var.policy_allowed_regions_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode(
    {
      listOfAllowedLocations = {
        value = var.policy_allowed_regions_list
      }
    }
  )
}

#https://github.com/Azure/azure-policy/tree/master/samples/built-in-policy/allowed-storageaccount-sku

resource "azurerm_resource_policy_assignment" "allowed_vm_skus" {
  name                 = "allowed_vm_skus"
  display_name         = "Allowed Virtual Machine SKUs"
  count                = var.policy_allowed_vm_skus_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  parameters = jsonencode(
    {
      listOfAllowedSKUs = {
        value = var.policy_allowed_vm_skus_list
      }
    }
  )
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkIPForwardingNic_Deny.json

resource "azurerm_resource_policy_assignment" "deny_ip_forwarding" {
  name                 = "deny_ip_forwarding"
  display_name         = "Prevent IP forwarding"
  count                = var.policy_deny_ip_forwarding_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
}

#https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkSecurityGroup_RDPAccess_Audit.json
resource "azurerm_resource_policy_assignment" "prevent_inbound_rdp" {
  name                 = "prevent_inbound_rdp"
  display_name         = "Prevent Inbound RDP"
  count                = var.policy_prevent_inbound_rdp_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e372f825-a257-4fb8-9175-797a8a8627d6"
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_NetworkSecurityGroupsOnSubnets_Audit.json 
# Note: https://github.com/Azure/azure-policy/tree/master/samples/Network/enforce-nsg-on-subnet

resource "azurerm_resource_policy_assignment" "associate_with_nsg" {
  name                 = "associate_with_nsg"
  display_name         = "Ensure subnets are associated with NSG"
  count                = var.policy_associate_with_nsg_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
}

# https://github.com/Azure/azure-policy/blob/bbfc60104c2c5b7fa6dd5b784b5d4713ddd55218/built-in-policies/policyDefinitions/Network/NetworkWatcher_Deploy.json
resource "azurerm_resource_policy_assignment" "networkwatcher_deploy" {
  name                 = "nw_deploy"
  display_name         = "Deploy network watcher when virtual networks are created"
  count                = var.policy_networkwatcher_deploy_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a9b99dd8-06c5-4317-8629-9d86a3c6e7d9"
  location             = var.location
  identity { type = "SystemAssigned" }
}

#https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkWatcher_Enabled_Audit.json
resource "azurerm_resource_policy_assignment" "networkwatcher_enabled_audit" {
  name                 = "nw_enabled_audit"
  display_name         = "Network Watcher should be enabled"
  count                = var.policy_networkwatcher_enabled_audit_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b6e2945c-0b7b-40f5-9233-7a5323b5cdc6"
  parameters = jsonencode(
    {
      listOfLocations = {
        value = var.networkwatcher_locations
      }
      resourceGroupName = {
        value = var.networkwatcher_rg
      }
    }
  )
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Storage/Storage_AuditForHTTPSEnabled_Audit.json
resource "azurerm_resource_policy_assignment" "https_to_storage" {
  name                 = "https_to_storage"
  display_name         = "Secure transfer to storage accounts should be enabled"
  count                = var.policy_networkwatcher_enabled_audit_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/SQL/SqlDBEncryption_Deploy.json
resource "azurerm_resource_policy_assignment" "sql_encryption" {
  name                 = "sql_encryption"
  display_name         = "Deploy SQL DB transparent data encryption"
  count                = var.policy_sql_encryption_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f"
  location             = var.location
  identity { type = "SystemAssigned" }
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/General/InvalidResourceTypes_Deny.json

resource "azurerm_resource_policy_assignment" "invalid_resource_types" {
  name                 = "invalid_resource_types"
  display_name         = "Not allowed resource types"
  count                = var.policy_invalid_resource_types_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"

  parameters = jsonencode(
    {
      listOfResourceTypesNotAllowed = {
        value = var.policy_invalid_resource_types_list
      }
    }
  )
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_Register_To_Azure_Security_Center_Deploy.json
resource "azurerm_resource_policy_assignment" "security_center_deploy" {
  name                 = "security_center_deploy"
  display_name         = "Enable Azure Security Center on your subscription"
  count                = var.policy_security_center_deploy_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac076320-ddcf-4066-b451-6154267e8ad2"
  location             = var.location
  identity { type = "SystemAssigned" }
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/InheritTag_Add_FromSubscription.json
/*resource "azurerm_resource_policy_assignment" "inherit_tags" {
  for_each             = toset(var.policy_inherit_sub_tags)
  name                 = "inherit_tag_${each.key}"
  display_name         = "Inherit the ${each.key} tag from the subscription if missing"
  resource_id                = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/40df99da-1232-49b1-a39a-6da8d878f469"
  location             = var.location
  identity { type = "SystemAssigned" }
  parameters = jsonencode(
    {
      tagName = {
        value = each.value
      }
    }
  )
} */

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_Deploy_auto_provisioning_log_analytics_monitoring_agent_default_workspace.json

resource "azurerm_resource_policy_assignment" "asc_monitoring" {
  name                 = "asc_monitoring"
  display_name         = "Enable Security Center's auto provisioning of the Log Analytics agent on your subscriptions with default workspace."
  count                = var.policy_asc_monitoring_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6df2fee6-a9ed-4fef-bced-e13be1b25f1c"
  location             = var.location
  identity { type = "SystemAssigned" }
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Guest%20Configuration/GuestConfiguration_Prerequisites.json

resource "azurerm_resource_policy_assignment" "enforce_inguest_monitoring" {
  name                 = "enforce_monitoring"
  display_name         = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
  count                = var.policy_enforce_inguest_monitoring_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8"
  location             = var.location
  identity { type = "SystemAssigned" }
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Backup/VirtualMachines_EnableAzureBackup_Audit.json

resource "azurerm_resource_policy_assignment" "enforce_vm_backup" {
  name                 = "enforce_vm_backup"
  display_name         = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
  count                = var.policy_enforce_vm_backup_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
}

# https://github.com/Azure/azure-policy/blob/bbfc60104c2c5b7fa6dd5b784b5d4713ddd55218/built-in-policies/policyDefinitions/Monitoring/DiagnosticSettingsForTypes_Audit.json

resource "azurerm_resource_policy_assignment" "audit_diagnostics" {
  name                 = "audit_diagnostics"
  display_name         = "Audit diagnostic setting"
  count                = var.policy_audit_diagnostics_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9"
  parameters = jsonencode(
    {
      listOfResourceTypes = {
        value = var.policy_audit_diagnostics_types_list
      }
    }
  )
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/SQL/SqlServerAuditing_Audit.json

resource "azurerm_resource_policy_assignment" "audit_sqlserver" {
  name                 = "audit_sqlserver"
  display_name         = "Auditing on SQL server should be enabled"
  count                = var.policy_audit_sqlservers_enable ? 1 : 0
  resource_id          = data.azurerm_management_group.main_management_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9"
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/AddTag_ResourceGroup_Modify.json

resource "azurerm_resource_policy_assignment" "RGRequireTags" {
  for_each             = var.policy_required_rg_tags
  name                 = "add_${each.key}_tag"
  display_name         = "Add the ${each.key} tag to all Resource groups"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/726aca4c-86e9-4b04-b0c5-073027359532"
  resource_id          = data.azurerm_management_group.main_management_group.id
  location             = var.location
  identity { type = "SystemAssigned" }
  parameters = jsonencode(
    {
      tagName = {
        value = each.key
      }
      tagValue = {
        value = each.value
      }
    }
  )
}

# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/InheritTag_Add_Modify.json

resource "azurerm_resource_policy_assignment" "RGInheritTags" {
  for_each             = toset(var.policy_inherit_rg_tags)
  name                 = "Inherit_${each.key}_tag"
  display_name         = "Inherit the ${each.key} tag to all Resources in a Resource group"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
  resource_id          = data.azurerm_management_group.main_management_group.id
  location             = var.location
  identity { type = "SystemAssigned" }
  parameters = jsonencode(
    {
      tagName = {
        value = each.key
      }
    }
  )
}