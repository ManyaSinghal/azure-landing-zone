## key vault certificate common vars

variable "key_vault_certificate_name" {
  description = "Specifies the name of the Key Vault Secret. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "cert_policy_values" {
  type        = any
  description = "Specifies the content type for the Key Vault Secret"
  default     = {}
}

variable "certificate_password" {
  type        = string
  description = "The password associated with the certificate. Changing this forces a new resource to be created"
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


