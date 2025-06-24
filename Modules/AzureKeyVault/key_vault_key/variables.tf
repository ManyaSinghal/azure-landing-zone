# key-vault-key vars

variable "key_vault_key_name" {
  type        = string
  description = "Specifies the name of the Key Vault Key. Changing this forces a new resource to be created"
  default     = ""
}

variable "key_vault_id" {
  description = "Specifies the id of the Management Lock. Changing this forces a new resource to be created"
  type        = string
  default     = ""
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

variable "curve" {
  type        = string
  description = "Specifies the curve to use when creating an EC key"
  default     = ""
}

variable "key_opts" {
  type        = list(string)
  description = "A list of JSON web key operations"
  default     = []
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

variable "key_vault_key_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}