# # General

variable "policy_name" {}
variable "policy_display_name" {}
variable "policy_resource_id" {}
variable "policy_definition_id" {}
variable "policy_parameters" {
  type = any
}

# variable "policies" {
#   type        = any
#   description = "*required* policy settings'"
# }

# variable "company_name" {
#   type        = string
#   default     = "Company"
#   description = "*required* The Company name ex. 'Contoso'"
# }

variable "location" {
  type        = string
  description = "Region name."
}

# variable "mainmanagement_group1_display_name" {
#   type        = string
#   description = "This is Main Management Group display name"
# }

# variable "networkwatcher_rg" {
#   type        = string
#   description = "Name of the resource group of NetworkWatcher, such as NetworkWatcherRG. This is the resource group where the Network Watchers are located."

# }

# variable "networkwatcher_locations" {
#   type        = list(string)
#   description = "Audit if Network Watcher is not enabled for region(s)."
# }

# #Policies

# # https://docs.rightscale.com/clouds/azure_resource_manager/reference/regions.html
# # az account list-locations -output table
# variable "policy_allowed_regions_list" {
#   type        = list(any)
#   description = "List of allowed Azure regions"
# }

# # https://docs.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
# variable "policy_allowed_storage_skus_list" {
#   type        = list(any)
#   description = "The list of SKUs that can be specified for storage accounts."
# }


# # az vm list-skus --location "CanadaCentral" --resource "virtualMachines"  --all --output table 
# variable "policy_allowed_vm_skus_list" {
#   type        = list(any)
#   description = "The list of SKUs that can be specified for vm accounts."
# }


# # Policy Enable/Disable
# variable "policy_allowed_regions_enable" {
#   type        = bool
#   default     = true
#   description = "Option to enable/disable the allowed regions policy"
# }

# variable "policy_allowed_storage_skus_enable" {
#   type        = bool
#   default     = true
#   description = "Option to enable/disable the allowed storage skus policy"
# }

# variable "policy_deny_ip_forwarding_enable" {
#   type        = bool
#   default     = true
#   description = "Option to enable/disable the deny_ip_forwarding policy"
# }

# variable "policy_prevent_inbound_rdp_enable" {
#   type        = bool
#   default     = true
#   description = "Option to enable/disable the prevent_inbound_rdp policy"
# }

# variable "policy_associate_with_nsg_enable" {
#   type        = bool
#   default     = true
#   description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."
# }

# variable "policy_networkwatcher_enabled_audit_enable" {
#   type        = bool
#   default     = true
#   description = "Network Watcher is a regional service that enables you to monitor and diagnose conditions at a network scenario level in, to, and from Azure. Scenario level monitoring enables you to diagnose problems at an end to end network level view. Network diagnostic and visualization tools available with Network Watcher help you understand, diagnose, and gain insights to your network in Azure."
# }

# variable "policy_networkwatcher_deploy_enable" {
#   type        = bool
#   default     = true
#   description = "This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances."
# }

# variable "policy_https_to_storage_enable" {
#   type        = bool
#   default     = true
#   description = "Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking."
# }

# variable "policy_sql_encryption_enable" {
#   type        = bool
#   default     = true
#   description = "Enables transparent data encryption on SQL databases"
# }

# variable "policy_invalid_resource_types_enable" {
#   type        = bool
#   default     = true
#   description = "Deny specific resource types."
# }

# # Get-AzResourceProvider -ListAvailable | Select-Object ProviderNamespace, RegistrationState
# variable "policy_invalid_resource_types_list" {
#   type        = list(string)
#   description = "The list of resource Types to be denied."
# }

# variable "policy_security_center_deploy_enable" {
#   type        = bool
#   default     = true
#   description = "Deny specific resource types."
# }

# variable "policy_inherit_sub_tags" {
#   type        = list(string)
#   description = "Name of the tag, such as 'environment', if none these policy is disabled."
# }

# variable "policy_asc_monitoring_enable" {
#   type        = bool
#   default     = true
#   description = "Allow Security Center to auto provision the Log Analytics agent on your subscriptions to monitor and collect security data using ASC default workspace."
# }

# variable "policy_enforce_inguest_monitoring_enable" {
#   type        = bool
#   default     = true
#   description = "Enforce VM in-guest monitoring Windows & Linux"
# }

# variable "policy_enforce_vm_backup_enable" {
#   type        = bool
#   default     = true
#   description = "Enforce Backup for all virtual machines Windows & Linux by deploying a recovery services vault in the same location and resource group as the virtual machine"
# }

# variable "policy_audit_diagnostics_enable" {
#   type        = bool
#   default     = true
#   description = "Audit diagnostic setting for selected resource types"
# }

# variable "policy_audit_diagnostics_types_list" {
#   type        = list(string)
#   description = "The list of resource Types to have diagnostic audit."
# }

# variable "policy_audit_sqlservers_enable" {
#   type        = string
#   description = "Auditing on your SQL Server should be enabled to track database activities across all databases on the server and save them in an audit log."
#   default     = true
# }

# variable "policy_required_rg_tags" {
#   type        = map(any)
#   description = "A map of key/value pairs. Each object will be a required tag and its default value on all resource groups created/updated going forward. Example: CostCenter - None"
# }

# variable "policy_inherit_rg_tags" {
#   type        = list(string)
#   description = "Each tag in this list will force inheritance from Resource Groups down to Resources"
# }
# variable "policy_allowed_vm_skus_enable" {
#   description = "Whether to enable the Azure Policy for allowed VM SKUs"
#   type        = bool
#   default     = false
# }

# # variable "policy_allowed_vm_skus_list" {
# #   description = "The list of allowed VM SKUs"
# #   type        = list(string)
# #   default     = []
# # }