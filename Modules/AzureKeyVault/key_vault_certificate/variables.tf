## key vault certificate common vars

variable "key_vault_cert_name" {
  description = "Specifies the name of the Key Vault Secret. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where the Secret should be created"
  type        = string
  default     = "westeurope"
}

variable "certificate_contents" {
  type        = string
  description = "The base64-encoded certificate contents. Changing this forces a new resource to be created"
  default     = ""
}

variable "certificate_password" {
  type        = string
  description = "The password associated with the certificate. Changing this forces a new resource to be created"
  default     = ""
}

variable "cert_policy_values" {
  type        = any
  description = "Specifies the content type for the Key Vault Secret"
  default     = {}
}

variable "key_vault_cert_tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


