
#Global Variables

variable "location" {
  type        = string
  description = "The unique lowercase alpha numeric identifier for resources for the project."
}

variable "company_name" {
  type        = string
  default     = "Company"
  description = "*required* The Company name ex. 'Contoso'"
}


#Management Groups

variable "deploy_managementgroups" {
  type        = bool
  description = "This is to deploy Management Groups"
}

variable "mainmanagement_group1_display_name" {
  type        = string
  description = "This is Main Management Group display name"
}

variable "management_group1_display_name" {
  type        = string
  description = "This is First Management Group display name"
}

variable "management_group1_subscription_ids" {
  type        = list(any)
  description = "This is First Management Group's list of Subscription Ids"
}

variable "management_group2_display_name" {
  type        = string
  description = "This is Second Management Group display name"
}

variable "management_group2_subscription_ids" {
  type        = list(any)
  description = "This is Second Management Group's list of Subscription Ids"
}

variable "management_group2a_display_name" {
  type        = string
  description = "This is 2a Management Group display name"
}

variable "management_group2a_subscription_ids" {
  type        = list(any)
  description = "This is 2a Management Group's list of Subscription Ids"
}

variable "management_group2b_display_name" {
  type        = string
  description = "This is 2b Management Group display name"
}

variable "management_group2b_subscription_ids" {
  type        = list(any)
  description = "This is 2b Management Group's list of Subscription Ids"
}

variable "management_group3_display_name" {
  type        = string
  description = "This is Third Management Group display name"
}

variable "management_group3_subscription_ids" {
  type        = list(any)
  description = "This is Third Management Group's list of Subscription Ids"
}

variable "management_group4_display_name" {
  type        = string
  description = "This is Fourth Management Group display name"
}

variable "management_group4_subscription_ids" {
  type        = list(any)
  description = "This is Fourth Management Group's list of Subscription Ids"
}

variable "mainmanagement_group_users_for_owner_role" {
  type        = list(any)
  description = "Add user ids to assign owner access on the main management group"
}

variable "mainmanagement_group_users_for_reader_role" {
  type        = list(any)
  description = "Add user ids to assign reader access on the main management group"
}

variable "mainmanagement_group_usergroups_for_owner_role" {
  type        = list(any)
  description = "Add user groups to assign owner access on the main management group"
}

variable "mainmanagement_group_usergroups_for_reader_role" {
  type        = list(any)
  description = "Add user groups to assign reader access on the main management group"
}


# Azure Standard Policies Variables

variable "deploy_policies" {
  type        = bool
  description = "This is to deploy Policies"
}

variable "networkwatcher_rg" {
  type        = string
  description = "Name of the resource group of NetworkWatcher. This is the resource group where the Network Watchers are located."

}

variable "networkwatcher_locations" {
  type        = list(string)
  description = "Audit if Network Watcher is not enabled for region(s)."
}

variable "policy_allowed_regions_list" {
  type        = list(any)
  description = "List of allowed Azure regions"
}

variable "policy_allowed_storage_skus_list" {
  type        = list(any)
  description = "The list of SKUs that can be specified for storage accounts."
}

variable "policy_allowed_vm_skus_list" {
  type        = list(any)
  description = "The list of SKUs that can be specified for vm accounts."
}

variable "policy_allowed_regions_enable" {
  type        = bool
  default     = true
  description = "Option to enable/disable the allowed regions policy"
}

variable "policy_allowed_storage_skus_enable" {
  type        = bool
  default     = true
  description = "Option to enable/disable the allowed storage skus policy"
}

variable "policy_allowed_vm_skus_enable" {
  type        = bool
  default     = true
  description = "Option to enable/disable the allowed vm skus policy"
}

variable "policy_deny_ip_forwarding_enable" {
  type        = bool
  default     = true
  description = "Option to enable/disable the deny_ip_forwarding policy"
}

variable "policy_prevent_inbound_rdp_enable" {
  type        = bool
  default     = true
  description = "Option to enable/disable the prevent_inbound_rdp policy"
}

variable "policy_associate_with_nsg_enable" {
  type        = bool
  default     = true
  description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."
}

variable "policy_networkwatcher_enabled_audit_enable" {
  type        = bool
  default     = true
  description = "Network Watcher is a regional service that enables you to monitor and diagnose conditions at a network scenario level in, to, and from Azure. Scenario level monitoring enables you to diagnose problems at an end to end network level view. Network diagnostic and visualization tools available with Network Watcher help you understand, diagnose, and gain insights to your network in Azure."
}

variable "policy_networkwatcher_deploy_enable" {
  type        = bool
  default     = true
  description = "This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances."
}

variable "policy_https_to_storage_enable" {
  type        = bool
  default     = true
  description = "Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking."
}

variable "policy_sql_encryption_enable" {
  type        = bool
  default     = true
  description = "Enables transparent data encryption on SQL databases"
}

variable "policy_invalid_resource_types_enable" {
  type        = bool
  default     = true
  description = "Deny specific resource types."
}

variable "policy_invalid_resource_types_list" {
  type        = list(string)
  description = "The list of resource Types to be denied."
}

variable "policy_security_center_deploy_enable" {
  type        = bool
  default     = true
  description = "Deny specific resource types."
}

variable "policy_inherit_sub_tags" {
  type        = list(string)
  description = "Name of the tag, such as 'environment', if none these policy is disabled."
}

variable "policy_asc_monitoring_enable" {
  type        = bool
  default     = true
  description = "Allow Security Center to auto provision the Log Analytics agent on your subscriptions to monitor and collect security data using ASC default workspace."
}

variable "policy_enforce_inguest_monitoring_enable" {
  type        = bool
  default     = true
  description = "Enforce VM in-guest monitoring Windows & Linux"
}

variable "policy_enforce_vm_backup_enable" {
  type        = bool
  default     = true
  description = "Enforce Backup for all virtual machines Windows & Linux by deploying a recovery services vault in the same location and resource group as the virtual machine"
}

variable "policy_audit_diagnostics_enable" {
  type        = bool
  default     = true
  description = "Audit diagnostic setting for selected resource types"
}

variable "policy_audit_diagnostics_types_list" {
  type        = list(string)
  description = "The list of resource Types to have diagnostic audit."
}

variable "policy_audit_sqlservers_enable" {
  type        = string
  description = "Auditing on your SQL Server should be enabled to track database activities across all databases on the server and save them in an audit log."
  default     = true
}

variable "policy_required_rg_tags" {
  type        = map(any)
  description = "A map of key/value pairs. Each object will be a required tag and its default value on all resource groups created/updated going forward. Example: CostCenter - None"
}

variable "policy_inherit_rg_tags" {
  type        = list(string)
  description = "Each tag in this list will force inheritance from Resource Groups down to Resources"
}

#Additional Resource Groups

variable "deploy_additionalresourcegroups" {
  type        = bool
  description = "This is to deploy additional Resource Groups"
}

variable "additional_resource_groups" {
  type        = map(any)
  description = "A list of Azure Resource groups required"
}

#Landing Zone Virtual Network Variables

variable "deploy_lzvirtualnetwork" {
  type        = bool
  description = "This is to deploy Landing Zone Virtual Network"
}

variable "network_rg_name" {
  type        = string
  description = "Name of the Networking resource group."
  default     = "RG-Networking"
}

variable "landingzone_vnet_name" {
  type        = string
  description = "The name of the Virtual Network"
  default     = "vnet-landingzone-001"
}

variable "landingzone_vnet_address_space" {
  type        = list(string)
  description = "The address space prefix for the virtual network in CIDR format"
  default     = ["10.0.0.0/16"]
}

variable "landingzone_vnet_dns_servers" {
  type        = list(string)
  description = "List of DNS Servers for the virtual network"
}

variable "landingzone_subnets" {
  type        = map(any)
  description = "A list of subnets and IP ranges for the VNET"
  default = {
    GatewaySubnet = ["10.0.250.0/24"]
  }
}

variable "landingzone_NSG_Prefix" {
  type        = string
  description = "The prefix used for network security groups"
  default     = "NSG"
}

variable "landingzone_vnet_tags" {
  type        = map(string)
  description = "The tags for the wan hub."

}

variable "landingzone_dcsubnet_name" {
  type        = string
  description = "The name of the DC Subnet"
}

#Identity Variables
variable "deploy_identity" {
  type        = bool
  description = "Whether or not to deploy the identity module"
  default     = false
}

variable "ident_dc_count" {
  type        = number
  description = "Number of DC VMs to be deployed (Allowed Values: 1 or 2 only)"
}

variable "ident_rg_name" {
  type        = string
  description = "Name of the identity resource group"
  default     = "RG-Identity"
}

variable "ident_dcstore_bootdiag_name" {
  type        = string
  description = "*Optional: Emtpy will auto-generate. The name of the storage account that will store the boot diagnostics for the domain controllers. Must be globally unique."
}

variable "ident_keyvault_name" {
  type        = string
  description = "*Optional: Emtpy will auto-generate. The name of key vault for the identity module. Must be globally unique."
}

variable "ident_recoveryservicesvault_name" {
  type        = string
  description = "The name of the recovery services vault for the identity module"
}

variable "ident_recoveryservicesvault_softdelete" {
  type        = bool
  description = "Whether Soft Delete is enabled on the recovery services vault"
}

variable "ident_dcavailset_name" {
  type        = string
  description = "The name of the Availability Set for the domain controllers"
}

variable "ident_dcavailset_fault_domain_count" {
  type        = number
  description = "Specifies the number of fault domains that are used. Defaults to 3."
}

variable "ident_dc01_nic_name" {
  type = string
}

variable "ident_dc02_nic_name" {
  type = string
}

variable "ident_dc01_nic_ip" {
  type = string
}

variable "ident_dc02_nic_ip" {
  type = string
}

variable "admin_username" {
  type        = string
  description = "The username for the local admin account on the VMs"
}

variable "admin_password" {
  type        = string
  description = "The password for the local admin account on the VMs"
}

variable "ident_dc_subnet_id" {
  description = "The ID of the subnet to associate with the network interface."
  type        = string
  default     = ""
}

variable "ident_dc01_name" {
  type = string
}

variable "ident_dc01_size" {
  type = string
}

variable "ident_dc02_name" {
  type = string
}

variable "ident_dc02_size" {
  type = string
}

variable "ident_backup_policy_name" {
  type        = string
  description = "The name of the retention policy for the Domain Controllers"
}

variable "ident_dcstore_bootdiag_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "ident_keyvault_tags" {
  type        = map(string)
  description = "The tags for the identy keyvault."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "ident_recoveryservicesvault_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

# VPN Gateway Variables
variable "deploy_vpn_gateway" {
  type        = bool
  default     = false
  description = "Set to true to deploy the VPN Gateway module"
}

variable "vpn_gateway_type" {
  type        = list(string)
  description = "Set to vpn or expressroute based on type of gateway is to be deployed"
}

variable "gtwy_vpn_name" {
  type    = string
  default = "VPN_Gateway"
}

variable "gtwy_vpn_sku" {
  type = string
}

variable "gtyw_vpn_generation" {
  type = string
}

variable "gtwy_local_address" {
  type        = string
  description = "The public IP address of the on-premise VPN device"
}

variable "gtwy_local_address_spaces" {
  type        = list(string)
  description = "A list of IP ranges used on-premises"
}

variable "gtwy_connection_private_key" {
  type        = string
  description = "The private connection key for the VPN connection"
}


variable "deploy_local_network_gtwy_connection" {
  type        = bool
  description = "This is to deploy local network gateway and create virtual network gateway(site-to-site) connection."
}


variable "gtwy_vpn_tags" {
  type        = map(string)
  description = "The tags for the public ip."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "gtwy_local_tags" {
  type        = map(string)
  description = "The tags for the public ip."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

# Express Route Variables

variable "deploy_expressroute" {
  type    = bool
  default = false
}

variable "expressroute_vpn_gtwy_name" {
  type    = string
  default = "ExpressRoute_Gateway"
}

variable "expressroute_circuit_name" {
  type = string
}

variable "expressroute_circuit_service_provider" {
  type = string
}

variable "expressroute_circuit_peering_location" {
  type = string
}

variable "expressroute_circuit_bandwidth" {
  type = number
}

variable "expressroute_circuit_sku" {
  type = string
}

variable "expressroute_circuit_family" {
  type = string
}

variable "expressroute_circuit_tags" {
  type        = map(string)
  description = "The tags for the expressroute circuit."

}

variable "expressroute_gtwy_vpn_tags" {
  type        = map(string)
  description = "The tags for the expressroute vpn gateway."

}

# Platform Management variables
variable "deploy_platform_management" {
  description = "Whether to deploy the platform management resources"
  type        = bool
  default     = false
}

variable "platform_management_rg_name" {
  description = "The name of the resource group for platform management components"
  type        = string
  default     = "TreyResearch-mgmt"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
  default     = "log-treyresearch-prod-001"
}

variable "log_analytics_retention_days" {
  description = "The number of days to retain data in Log Analytics"
  type        = number
  default     = 30
}

variable "automation_account_name" {
  description = "The name of the Azure Automation account"
  type        = string
  default     = "auto-treyresearch-prod-001"
}

variable "sentinel_enabled" {
  description = "Whether to enable Microsoft Sentinel on the Log Analytics workspace"
  type        = bool
  default     = false
}

# Platform Connectivity variables
variable "deploy_platform_connectivity" {
  description = "Whether to deploy the platform connectivity resources"
  type        = bool
  default     = false
}

variable "platform_connectivity_rg_name" {
  description = "The name of the resource group for platform connectivity components"
  type        = string
  default     = "TreyResearch-Connectivity"
}

variable "platform_vnet_name" {
  description = "The name of the platform virtual network"
  type        = string
  default     = "vnet-platform-prod-01"
}

variable "platform_vnet_address_space" {
  description = "The address space for the platform virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "platform_vnet_dns_servers" {
  description = "The DNS servers for the platform virtual network"
  type        = list(string)
  default     = []
}

variable "platform_vnet_tags" {
  description = "Tags to apply to the platform virtual network"
  type        = map(string)
  default = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

variable "platform_subnets" {
  description = "A map of subnet names to address prefixes"
  type        = map(list(string))
  default = {
    snet-platform-connectivity = ["10.0.1.0/24"]
    snet-platform-mgmt         = ["10.0.2.0/24"]
    GatewaySubnet              = ["10.0.0.0/27"]
    AzureFirewallSubnet        = ["10.0.0.64/26"]
  }
}

variable "deploy_azure_firewall" {
  description = "Whether to deploy Azure Firewall"
  type        = bool
  default     = false
}

variable "azure_firewall_name" {
  description = "The name of the Azure Firewall"
  type        = string
  default     = "fw-platform-prod-01"
}

variable "azure_firewall_sku_tier" {
  description = "The SKU tier of the Azure Firewall"
  type        = string
  default     = "Standard"
}

variable "azure_firewall_sku_name" {
  description = "The SKU name of the Azure Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "azure_firewall_tags" {
  description = "Tags to apply to the Azure Firewall"
  type        = map(string)
  default = {
    CostCenter = "None"
    Env        = "Prod"
  }
}

# New variables for multiple subscription support

variable "platform_subscription_id" {
  description = "The subscription ID for the platform resources"
  type        = string
  default     = "3e96e598-99b1-4f61-8b48-8a66790f3cd0" # Replace with your actual platform subscription ID
}

variable "ident_dc_admin_username" {
  type        = string
  description = "The username for the local admin account on the VMs"
}

variable "ident_dc_admin_password" {
  type        = string
  description = "The password for the local admin account on the VMs"
}


