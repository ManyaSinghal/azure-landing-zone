variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "The location in which the resources will be created."
  type        = string
  default     = ""
}

variable "disk_name" {
  description = "The name of the managed disk."
  type        = string
  default     = ""
}

variable "storage_account_type" {
  description = "Specifies the storage account type for the managed disk. Possible values are Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, Standard_ZRS."
  type        = string
  default     = "Standard_LRS"
}

variable "disk_size_gb" {
  description = "Specifies the size of the managed disk in gigabytes."
  type        = number
  default     = 128
}

variable "managed_disk_tags" {
  description = "Specifies the create option for the managed disk. Possible values are Empty, Copy, Import, Restore, and Attach."
  type        = map(string)
  default     = {}
}

variable "create_option" {
  description = "Specifies the create option for the managed disk. Possible values are Empty, Copy, Import, Restore, and Attach."
  type        = string
  default     = "Empty"
}

variable "vm_id" {
  description = "The ID of the virtual machine to which the managed disk will be attached."
  type        = string
  default     = ""
}

variable "lun" {
  description = "The logical unit number (LUN) of the managed disk when attached to the virtual machine."
  type        = number
  default     = 0

}