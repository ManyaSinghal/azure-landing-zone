
## keyvault common vars

variable "key_vault_id" {
  description = "Specifies the id of the Key Vault resource. Changing this forces a new resource to be created"
  type        = string
  default     = ""
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