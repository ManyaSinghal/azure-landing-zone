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

variable "rsv_name" {
  type        = string
  description = "The name of the recovery services vault for the identity module"
}

variable "rsv_soft_delete" {
  type        = bool
  description = "Whether Soft Delete is enabled on the recovery services vault"
}

variable "backup_policy_name" {
  type        = string
  description = "The name of the retention policy for the Domain Controllers"
}


variable "rsv_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "vm_ids" {

}