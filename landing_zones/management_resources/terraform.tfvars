mg_name = "treyresearch"
treyresearch_mg = {
  mg1 = {
    display_name     = "platform"
    subscription_ids = ["b8e8b895-9267-4bf3-9ea4-9b3fd73d9064"]
  }
  mg2 = {
    display_name     = "landing_zones"
    subscription_ids = ["9028f9f3-b30b-448e-8d66-89dc5f70952a", "444d8314-f8ed-4391-a132-54a5ce2e54bb"]
  }
  mg3 = {
    display_name     = "sandboxes"
    subscription_ids = []
  }
  mg4 = {
    display_name     = "decommisiioned"
    subscription_ids = []
  }
}

lz_mg = {
  mg1 = {
    display_name     = "core"
    mg_key           = "mg2"
    subscription_ids = ["9028f9f3-b30b-448e-8d66-89dc5f70952a"]
  }
  mg2 = {
    display_name     = "online"
    mg_key           = "mg2"
    subscription_ids = ["444d8314-f8ed-4391-a132-54a5ce2e54bb"]
  }
}

policies = {
  #https://github.com/Azure/azure-policy/blob/master/samples/built-in-policy/allowed-locations/
  p1 = {
    policy_name          = "allowed_regions"
    policy_display_name  = "Allowed Azure Region for Resources and Resource Groups"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    policy_parameters = {
      listOfAllowedLocations = {
        value = ["West US"]
      }
    }
  }
  #https://github.com/Azure/azure-policy/tree/master/samples/built-in-policy/allowed-storageaccount-sku
  p2 = {
    policy_name          = "allowed_vm_skus"
    policy_display_name  = "Allowed Virtual Machine SKUs"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
    policy_parameters = {
      listOfAllowedSKUs = {
        value = ["Standard_B1s", "Standard_B2s", "Standard_B4ms", "Standard_B8ms", "Standard_DS1_v2", "Standard_DS2_v2", "Standard_DS3_v2", "Standard_DS4_v2"]
      }
    }
  }
  # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkIPForwardingNic_Deny.json
  p3 = {
    policy_name          = "deny_ip_forwarding"
    policy_display_name  = "Prevent IP forwarding"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
    policy_parameters    = null
  }
  #https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkSecurityGroup_RDPAccess_Audit.json
  p4 = {
    policy_name          = "prevent_inbound_rdp"
    policy_display_name  = "Prevent Inbound RDP"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e372f825-a257-4fb8-9175-797a8a8627d6"
    policy_parameters    = null
  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_NetworkSecurityGroupsOnSubnets_Audit.json 
  # Note: https://github.com/Azure/azure-policy/tree/master/samples/Network/enforce-nsg-on-subnet
  p5 = {
    policy_name          = "associate_with_nsg"
    policy_display_name  = "Ensure subnets are associated with NSG"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
    policy_parameters    = null
  }

  # # https://github.com/Azure/azure-policy/blob/bbfc60104c2c5b7fa6dd5b784b5d4713ddd55218/built-in-policies/policyDefinitions/Network/NetworkWatcher_Deploy.json
  p6 = {
    policy_name          = "nw_deploy"
    policy_display_name  = "Deploy network watcher when virtual networks are created"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a9b99dd8-06c5-4317-8629-9d86a3c6e7d9"
    location             = "Canada Central" #Target LZ region
    policy_parameters    = null
  }
  # #https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Network/NetworkWatcher_Enabled_Audit.json  
  p7 = {
    policy_name          = "nw_enabled_audit"
    policy_display_name  = "ANetwork Watcher should be enabled"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b6e2945c-0b7b-40f5-9233-7a5323b5cdc6"
    policy_parameters = {
      listoflocations = {
        value = ["West US"]
      }
      resourcegroupname = {
        value = "rg-prod-networkwatcher"
      }
    }
  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Storage/Storage_AuditForHTTPSEnabled_Audit.json
  p8 = {
    policy_name          = "https_to_storage"
    policy_display_name  = "Secure transfer to storage accounts should be enabled"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    policy_parameters    = null
  }

  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/SQL/SqlDBEncryption_Deploy.json
  p9 = {
    policy_name          = "sql_encryption"
    policy_display_name  = "Deploy SQL DB transparent data encryption"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f"
    location             = "Canada Central" #Target LZ region
    policy_parameters    = null
  }

  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/General/InvalidResourceTypes_Deny.json
  p10 = {
    policy_name          = "invalid_resource_types"
    policy_display_name  = "Not allowed resource types"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
    policy_parameters = {
      listOfResourceTypesNotAllowed = {
        value = [
          "Microsoft.MixedReality",
          "Microsoft.Maps",
          "Microsoft.DataMigration"
        ]
      }
    }
  }

  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_Register_To_Azure_Security_Center_Deploy.json
  p11 = {
    policy_name          = "security_center_deploy"
    policy_display_name  = "Enable Azure Security Center on your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac076320-ddcf-4066-b451-6154267e8ad2"
    location             = "Canada Central" #Target LZ region
    policy_parameters    = null
  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Security%20Center/ASC_Deploy_auto_provisioning_log_analytics_monitoring_agent_default_workspace.json
  p12 = {
    policy_name          = "asc_monitoring"
    policy_display_name  = "Enable Security Center's auto provisioning of the Log Analytics agent on your subscriptions with default workspace."
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6df2fee6-a9ed-4fef-bced-e13be1b25f1c"
    location             = "Canada Central" #Target LZ region
    policy_parameters    = null

  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Guest%20Configuration/GuestConfiguration_Prerequisites.json
  p13 = {
    policy_name          = "enforce_monitoring"
    policy_display_name  = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
    policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8"
    location             = "Canada Central" #Target LZ region
    policy_parameters    = null
  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Backup/VirtualMachines_EnableAzureBackup_Audit.json
  p14 = {
    policy_name          = "enforce_vm_backup"
    policy_display_name  = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
    policy_parameters    = null
  }
  # # https://github.com/Azure/azure-policy/blob/bbfc60104c2c5b7fa6dd5b784b5d4713ddd55218/built-in-policies/policyDefinitions/Monitoring/DiagnosticSettingsForTypes_Audit.json
  p15 = {
    policy_name          = "audit_diagnostics"
    policy_display_name  = "Audit diagnostic setting"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9"
    policy_parameters = {
      listOfResourceTypes = {
        value = [
          "Microsoft.Compute",
          "Microsoft.Network"
        ]
      }
    }
  }

  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/SQL/SqlServerAuditing_Audit.json
  p16 = {
    policy_name          = "audit_sqlserver"
    policy_display_name  = "Auditing on SQL server should be enabled"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9"
    policy_parameters    = null
  }

  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/AddTag_ResourceGroup_Modify.json
  p17 = {
    policy_name          = "add_CostCenter_tag"
    policy_display_name  = "Add the CostCenter tag to all Resource groups"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/726aca4c-86e9-4b04-b0c5-073027359532"
    location             = "Canada Central" #Target LZ region
    policy_parameters = {
      tagName = {
        value = "CostCenter"
      }
      tagValue = {
        value = "None"
      }
    }
  }
  p18 = {
    policy_name          = "add_Env_tag"
    policy_display_name  = "Add the Env tag to all Resource groups"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/726aca4c-86e9-4b04-b0c5-073027359532"
    location             = "Canada Central" #Target LZ region
    policy_parameters = {
      tagName = {
        value = "Env"
      }
      tagValue = {
        value = "Prod"
      }
    }
  }
  # # https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/InheritTag_Add_Modify.json
  p19 = {
    policy_name          = "add_Env_tag"
    policy_display_name  = "Add the Env tag to all Resource groups"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/726aca4c-86e9-4b04-b0c5-073027359532"
    location             = "Canada Central" #Target LZ region
    policy_parameters = {
      tagName = {
        value = "Env"
      }
    }
  }
  p20 = {
    policy_name          = "add_CostCenter_tag"
    policy_display_name  = "Add the CostCenter tag to all Resource groups"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/726aca4c-86e9-4b04-b0c5-073027359532"
    location             = "Canada Central" #Target LZ region
    policy_parameters = {
      tagName = {
        value = "CostCenter"
      }
    }
  }
}