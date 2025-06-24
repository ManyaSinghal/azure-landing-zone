
## key vault certificate issuer common vars

variable "name" {
  description = "The name which should be used for this Key Vault Certificate Issuer. Changing this forces a new Key Vault Certificate Issuer to be created"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "The ID of the Key Vault in which to create the Certificate Issuer"
  type        = string
  default     = ""
}

variable "provider_name" {
  type        = string
  description = "The name of the third-party Certificate Issuer"
  default     = ""
}

variable "org_id" {
  type        = string
  description = "The ID of the organization as provided to the issuer"
  default     = ""
}

variable "account_id" {
  type        = string
  description = "The account number with the third-party Certificate Issuer"
  default     = ""
}

variable "password" {
  type        = string
  description = "The password associated with the account and organization ID at the third-party Certificate Issuer"
  default     = ""
  sensitive   = true
}

# admin vars
variable "admin_values" {
  type        = any
  description = "One or more admin blocks as defined below"
  default     = {}
}



