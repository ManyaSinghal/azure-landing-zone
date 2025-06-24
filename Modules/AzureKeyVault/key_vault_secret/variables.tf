##  key vault secrets common vars

variable "key_secret_name" {
  description = "Specifies the name of the Key Vault Secret. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "value" {
  description = "Specifies the value of the Key Vault Secret"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where the Secret should be created"
  type        = string
  default     = "westeurope"
}

variable "content_type" {
  type        = string
  description = "Specifies the content type for the Key Vault Secret"
  default     = ""
}

variable "not_before_date" {
  type        = string
  description = "Key not usable before the provided UTC datetime"
  default     = null
}

variable "expiration_date" {
  type        = string
  description = "Expiration UTC datetime"
  default     = null
}

variable "key_secret_tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


