
## key vault certificate issuer common vars
variable "name" {
  description = "The name which should be used for this Key Vault Certificate Issuer. Changing this forces a new Key Vault Certificate Issuer to be created"
  type        = string
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



