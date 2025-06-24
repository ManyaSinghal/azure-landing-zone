
## keyvault common vars

variable "key_vault_name" {
  description = "Specifies the name of the Key Vault resource. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure location where resources should be deployed."
  type        = string
  default     = "westeurope"
}

variable "sku_name" {
  type        = string
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
  default     = ""
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
  default     = null
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Disk Encryption to retrieve secrets from the vault and unwrap keys."
  default     = null
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow Resource Manager to retrieve secrets from the key vault."
  default     = null
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
  default     = null
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Allow purge_protection be enabled for this Key Vault"
  default     = true
}


variable "soft_delete_retention_days" {
  type        = number
  description = "he number of days that items should be retained for once soft-deleted"
  default     = 90
}

variable "key_vault_tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


# Network acl vars
variable "network_acls" {
  description = "Network rules to apply to key vault."
  type        = any
  default     = {}
}

# contact vars
variable "contact" {
  description = "Network rules to apply to key vault."
  type        = any
  default     = {}
}


## key vault policy 

variable "policies" {
  type = map(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  }))
  description = "Define a Azure Key Vault access policy"
  default     = {}
}