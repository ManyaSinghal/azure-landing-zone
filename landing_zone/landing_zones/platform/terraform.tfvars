#Global

#The location in Azure that objects will be created in
location = "Canada Central" #Target LZ region

#The company name
company_name = "Softchoice"

# Management Groups - Updated to match architecture diagram
deploy_managementgroups = true
#Top level MG under the tenant root
mainmanagement_group1_display_name = "TreyResearch"
#For the below additional Management Groups 2 to 4, pass the name only if intending to deploy them else a blank name ""(no whitespace) will skip the respective MG creation. 
management_group1_display_name     = "Platform"
management_group1_subscription_ids = ["b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"] # Replace with actual subscription ID

management_group2_display_name     = "Landing Zones"
management_group2_subscription_ids = [] # Replace with actual subscription IDs

management_group2a_display_name     = "Corp-LZ"
management_group2a_subscription_ids = ["9028f9f3-b30b-448e-8d66-89dc5f70952a"] # Replace with actual subscription IDs

management_group2b_display_name     = "Online-LZ"
management_group2b_subscription_ids = ["444d8314-f8ed-4391-a132-54a5ce2e54bb"] # Replace with actual subscription IDs

management_group3_display_name     = "Sandboxes"
management_group3_subscription_ids = [] # Replace with actual subscription ID

management_group4_display_name     = "Decommissioned"
management_group4_subscription_ids = [] # Add subscription IDs when needed

# If you do not intend to assign roles for user/usergroups, please pass blank list '[]' for the below respective variables.
mainmanagement_group_users_for_owner_role       = []
mainmanagement_group_users_for_reader_role      = []
mainmanagement_group_usergroups_for_owner_role  = []
mainmanagement_group_usergroups_for_reader_role = []

#Azure Standard Policies
deploy_policies = false

policy_allowed_regions_enable = true
policy_allowed_regions_list = [
  "West US"
]
# VM SKUs Policy
policy_allowed_vm_skus_enable = true
policy_allowed_vm_skus_list = [
  "Standard_B1s", "Standard_B2s", "Standard_B4ms", "Standard_B8ms", "Standard_DS1_v2", "Standard_DS2_v2", "Standard_DS3_v2", "Standard_DS4_v2"
]
policy_allowed_storage_skus_enable = true
policy_allowed_storage_skus_list = [
  "Standard_LRS",
  "Standard_GRS",
  "Standard_RAGRS",
  "Standard_ZRS",
  "Premium_LRS",
]
policy_deny_ip_forwarding_enable    = true
policy_prevent_inbound_rdp_enable   = true
policy_associate_with_nsg_enable    = true
policy_networkwatcher_deploy_enable = true
networkwatcher_rg                   = "rg-prod-networkwatcher"
networkwatcher_locations = [
  "West US"
]
policy_networkwatcher_enabled_audit_enable = true
policy_https_to_storage_enable             = true
policy_sql_encryption_enable               = true
policy_invalid_resource_types_enable       = true

policy_invalid_resource_types_list = [
  "Microsoft.MixedReality",
  "Microsoft.Maps",
  "Microsoft.DataMigration"
]
policy_security_center_deploy_enable = true
policy_inherit_sub_tags = [
  "CostCenter"
]
policy_asc_monitoring_enable             = true
policy_enforce_inguest_monitoring_enable = true
policy_enforce_vm_backup_enable          = true
policy_audit_diagnostics_enable          = true
policy_audit_diagnostics_types_list = [
  "Microsoft.Compute",
  "Microsoft.Network"
]
policy_audit_sqlservers_enable = true
#Tags required on Resource Groups
policy_required_rg_tags = {
  CostCenter = "None"
  Env        = "Prod"
}
#Which tags resources should inherit from their Resource Groups
policy_inherit_rg_tags = [
  "CostCenter",
  "Env"
]

# Additional Resoruce Groups

deploy_additionalresourcegroups = false

additional_resource_groups = {
  # Existing landing zone resource groups
  rg-prod-usw-vm-AC-IT = "West US"

  # New platform subscription resource groups
  #TreyResearch-mgmt = "West US"
  #TreyResearch-Connectivity = "West US"
  #TreyResearch-Identity = "West US"
}

#Platform Management Resources
deploy_platform_management   = true
platform_management_rg_name  = "TreyResearch-mgmt"
log_analytics_workspace_name = "log-treyresearch-prod-001"
log_analytics_retention_days = 30
automation_account_name      = "auto-treyresearch-prod-001"
sentinel_enabled             = true

#Platform Connectivity Resources
deploy_platform_connectivity  = true
platform_connectivity_rg_name = "TreyResearch-Connectivity"
platform_vnet_name            = "vnet-platform-prod-01"
platform_vnet_address_space   = ["10.0.0.0/16"]
platform_vnet_dns_servers     = ["10.0.0.1", "10.0.0.2"]
platform_vnet_tags = {
  CostCenter = "None"
  Env        = "Prod"
}

# Platform connectivity subnets
platform_subnets = {
  snet-platform-connectivity = ["10.0.1.0/24"]
  snet-platform-mgmt         = ["10.0.2.0/24"]
  GatewaySubnet              = ["10.0.0.0/27"]
  AzureFirewallSubnet        = ["10.0.0.64/26"]
}

# Platform Azure Firewall
deploy_azure_firewall   = true
azure_firewall_name     = "fw-platform-prod-01"
azure_firewall_sku_tier = "Standard"
azure_firewall_sku_name = "AZFW_VNet"
azure_firewall_tags = {
  CostCenter = "None"
  Env        = "Prod"
}

#Landing Zone Virtual Network
deploy_lzvirtualnetwork = false

#Resource Group Name for Networking RG
network_rg_name = "rg-prod-usw-vnet-01"

#Virtual network Name
landingzone_vnet_name = "vnet-prod-usw-01"

#Virtual Network address space. 
#Separate with commas. Example: ["10.0.0.0/16","10.0.1.0/16"]
landingzone_vnet_address_space = ["10.15.0.0/16"]

#Virtual Network DNS Servers. Set to an on prem DC initially.
#Separate with commas. Example: ["10.0.0.1", "10.0.0.2"]
#To set Azure default DNS comment line #11 in main file within LZ VNET Module.
landingzone_vnet_dns_servers = ["10.0.0.1", "10.0.0.2"]

#The prefix prepended to the name of the network security groups for each subnet
landingzone_NSG_Prefix = "NSG"

landingzone_vnet_tags = {
  CostCenter = "None"
  Env        = "Prod"
}

#The name of the DC Subnet. This must be defined for the identity module
#MUST match one of the subnet names (below) and it will be used as the subnet for DCs deployment
landingzone_dcsubnet_name = "snet-prod-usw-dc"

#A list of subnets being added to the VNET
#Format: Name = ListOfSubnets
#Example: PrimarySubnet = ["10.0.0.0/24"]
#Example: SecondarySubnet = ["10.0.1.0/24","10.0.2.0/24"]
#Important Note: If you don't plan to deploy domain controller or vpn gateway/expressroute, please remove or do not add subnets below for them.
landingzone_subnets = {
  snet-prod-usw-dc = ["10.15.1.0/24"]
  snet-prod-usw-vm = ["10.15.2.0/24"]
  GatewaySubnet    = ["10.15.0.0/27"]
}

#Identity (Domain Controllers)

#Whether or not to deploy the identity module. Set to 'true' to deploy.
deploy_identity = false

#Number of Domain Controllers
ident_dc_count = 2 #Allowed values are only 1 or 2.

#Important: If ident_dc_count(above) is set to 1, assigning values to all the below variables for DC VM2 and Availability Set are not required

#Username for Domain Controllers
ident_dc_admin_username = "azadmin"
#Password for Domain Controllers - Consider using a secure method or key vault reference
ident_dc_admin_password = "TFSI@2021###3*"
#Storage Account for Boot Diagnostics for Domain Controllers name
ident_dcstore_bootdiag_name = "tfsivmbootdiag2021"

#Identity Resource Group name
ident_rg_name       = "TreyResearch-Identity"
ident_keyvault_name = "kv-ident-prod-001"
#Name of the Recovery Services Vault for Identity Objects
ident_recoveryservicesvault_name = "rsv-ident-prod-001"
#Whether 'Soft Delete' is enabled. Set to true for production
#If set to true, deleting the recovery services vault will fail until 7 days later.
ident_recoveryservicesvault_softdelete = true
#Name of the Availability Set for the domain controllers
ident_dcavailset_name = "avail-ident-prod-001"
#Count of the Fault domain for the DC Availability Set
ident_dcavailset_fault_domain_count = 2
#Name of DC01 NIC Card
ident_dc01_nic_name = "nic-ident-prod-001"
#Name of DC02 NIC Card 
ident_dc02_nic_name = "nic-ident-prod-002"
#Static IP Address of DC01
ident_dc01_nic_ip = "10.0.2.4"
#Static IP Address of DC02
ident_dc02_nic_ip = "10.0.2.5"
#Name of DC01
ident_dc01_name = "DC01"
#VM Size of DC01
ident_dc01_size = "Standard_B2s"
#Name of DC02
ident_dc02_name = "DC02"
#VM Size of DC02
ident_dc02_size = "Standard_B2s"
#Name of the Backup Policy for Domain Controllers
ident_backup_policy_name = "DC_Backup_Policy"

ident_dcstore_bootdiag_tags = {
  CostCenter = "None"
  Env        = "Prod"
  Department = "IT"
}
ident_keyvault_tags = {
  CostCenter = "None"
  Env        = "Prod"
  Department = "IT"
}
ident_recoveryservicesvault_tags = {
  CostCenter = "None"
  Env        = "Prod"
  Department = "IT"
}

#Networking- VPN Gateway

#Whether or not the VPN Gateway module is deployed. Set to true to deploy.
deploy_vpn_gateway = false

#Select the Gateway type by typing "vpn" or "expressroute" (Case sensitive) or both in the [] brackets. 
#It allows both values at once as well, as a result it will create both gateway types
vpn_gateway_type = ["vpn", "expressroute"]


#Gateway Type: VPN 

#Update the variable values below if you have wish to deploy VPN type Gateway, 
#else go to next section of variables for Express Route

#Name of VPN Gateway with gateway type: VPN 
gtwy_vpn_name = "vgw-prod-usw-vpn"
#Private Key (Secret) for VPN Gateway Connection
gtwy_connection_private_key = "AmeriCash#AzureS2SVPN#SharedKey*"
#The Public IP address of the On-Premises VPN prodice (Supplied by customer)
gtwy_local_address = "184.105.85.150"
#The list of local address ranges for routing purposes - Separate with commas
gtwy_local_address_spaces = ["184.105.85.128/27"]
#The Gateway VPN Sku - Basic for Testing, but use Standard or better for production
gtwy_vpn_sku = "VpnGw1"
#VPN Gateway Generation
gtyw_vpn_generation = "Generation1"

# This is to deploy local network gateway and create virtual network gateway(site-to-site) connection.
deploy_local_network_gtwy_connection = false

gtwy_vpn_tags = {
  CostCenter = "None"
  Env        = "Prod"
}
gtwy_local_tags = {
  CostCenter = "None"
  Env        = "Prod"
}

#Update the variable values below if you have wish to deploy Express Route type Gateway,
# If vpn type gateway is to be deployed, please refer to the above variable and update.

#Name of VPN Gateway with gateway type: ExpressRoute
expressroute_vpn_gtwy_name = "vgw-platform-expressroute"
#Name of the Express Route Circuit
expressroute_circuit_name = "prod-az-ExpressRoute"
#Service Provider - Customer Supplies
expressroute_circuit_service_provider = "Equinix"
#Peering Location - Custom Supplies
expressroute_circuit_peering_location = "Silicon Valley"
#Bandwidth available on the express route circuit
expressroute_circuit_bandwidth = 50
#Circuit SKU
expressroute_circuit_sku = "Standard"
#Circuit Family
expressroute_circuit_family = "MeteredData"

expressroute_gtwy_vpn_tags = {
  CostCenter = "None"
  Env        = "Prod"
  Department = "IT"
}

expressroute_circuit_tags = {
  CostCenter = "None"
  Env        = "Prod"
  Department = "IT"
}

# Admin credentials for VMs
admin_username = "azureuser"
admin_password = "ComplexP@ssw0rd123!"

# Identity DC subnet ID (only needed if identity module is deployed)
ident_dc_subnet_id = ""

# Subscription IDs for multi-subscription deployment
platform_subscription_id = "b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"
