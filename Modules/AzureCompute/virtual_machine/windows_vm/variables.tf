## windows_vm common vars

variable "windows_vm_name" {
  description = "name of the azure vm"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "The location in which the resources will be created."
  type        = string
  default     = ""
}

variable "availability_set_id" {
  description = "The ID of the Availability Set in which the Virtual Machine should exist"
  type        = string
  default     = null
}

variable "windows_vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "network_interface_ids" {
  description = "A list of Network Interface ID's which should be associated with the Virtual Machine"
  type        = list(string)
  default     = []
}

variable "license_type" {
  description = "Specifies the BYOL Type for this Virtual Machine. This is only applicable to Windows Virtual Machines. Possible values are Windows_Client and Windows_Server"
  type        = string
  default     = null
}

variable "zones" {
  description = "A list of a single item of the Availability Zone which the Virtual Machine should be allocated in"
  type        = list(string)
  default     = []
}

variable "admin_username" {}
variable "admin_password" {}

variable "windows_vm_tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."
  default     = {}
}

# boot diagnostics vars
variable "boot_diagnostics" {
  description = "boot diagnostics block"
  type        = map(string)
  default     = {}
}

# additional capabilities vars
variable "ultra_ssd_enabled" {
  description = "Should Ultra SSD disk be enabled for this Virtual Machine"
  type        = bool
  default     = false
}

# identity vars
variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

# os profile vars
variable "os_disk" {
  description = "data disk storage details"
  type        = map(string)
  default     = {}
}


# os_profile_windows_config
variable "os_profile_windows_config" {
  description = "Specifies how the data disk should be created"
  type        = map(string)
  default     = {}
}

# plan vars 
variable "plan" {
  description = "Specifies image from the marketplace."
  # type        = map(string)
  default = {}
}

# storage image reference vars
variable "source_image_reference" {
  description = "Azure Platform Image (e.g. Ubuntu/Windows Server) or a Custom Image"
  type        = map(string)
  default     = {}
}








