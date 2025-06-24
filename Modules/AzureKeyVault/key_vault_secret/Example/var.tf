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


variable "content_type" {
  type        = string
  description = "Specifies the content type for the Key Vault Secret"
  default     = "password"
}


variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}


