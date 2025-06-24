
## keyvault common vars

variable "name" {
  description = "Specifies the name of the Management Lock. Changing this forces a new resource to be created"
  type        = string
  default     = ""
}

variable "sku_name" {
  type        = string
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}


variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


# key-vault-key vars

variable "create_key_vault_key" {
  type        = bool
  description = "condition to create to key vault key or not"
  default     = false
}

variable "key_vault_key_name" {
  type        = string
  description = "Specifies the name of the Key Vault Key. Changing this forces a new resource to be created"
}

variable "key_type" {
  type        = string
  description = " Specifies the Key Type to use for this Key Vault Key"
  default     = "RSA"
}

variable "key_size" {
  type        = number
  description = "Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048"
  default     = 2048
}

variable "key_vault_key_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}