variable "location" {
  type        = string
  description = "Location in azure to create objects"
}

variable "ident_dc_count" {
  type        = number
  description = "Number of DC VMs to be deployed"
}

variable "ident_rg_name" {
  type        = string
  description = "Name of the identity resource group"
}

variable "ident_dcstore_bootdiag_name" {
  type        = string
  description = "*Optional: Emtpy will auto-generate. The name of the storage account that will store the boot diagnostics for the domain controllers."
}

variable "ident_keyvault_name" {
  type        = string
  description = "*Optional: Emtpy will auto-generate. The name of key vault for the identity module. Must be globally unique."
}

variable "ident_recoveryservicesvault_name" {
  type        = string
  description = "The name of the recovery services vault for the identity module"
}

variable "ident_recoveryservicesvault_softdelete" {
  type        = bool
  description = "Whether Soft Delete is enabled on the recovery services vault"
}

variable "ident_dcavailset_name" {
  type        = string
  description = "The name of the Availability Set for the domain controllers"
}

variable "ident_dcavailset_fault_domain_count" {
  type        = number
  description = "Specifies the number of fault domains that are used. Defaults to 3."
}

variable "ident_dc_subnet_id" {
  type        = string
  description = "The ID of the subnet to place the domain controllers in"
}

variable "ident_dc01_nic_name" {
  type = string
}

variable "ident_dc02_nic_name" {
  type = string
}

variable "ident_dc01_nic_ip" {
  type = string
}

variable "ident_dc02_nic_ip" {
  type = string
}

variable "ident_dc_admin_username" {
  type        = string
  description = "The username for the local admin account on the VMs"
}

variable "ident_dc_admin_password" {
  type        = string
  description = "The password for the local admin account on the VMs"
}

variable "ident_dc01_name" {
  type = string
}

variable "ident_dc01_size" {
  type = string
}

variable "ident_dc02_name" {
  type = string
}

variable "ident_dc02_size" {
  type = string
}

variable "ident_backup_policy_name" {
  type        = string
  description = "The name of the retention policy for the Domain Controllers"
}

variable "ident_dcstore_bootdiag_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "ident_keyvault_tags" {
  type        = map(string)
  description = "The tags for the identy keyvault."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}

variable "ident_recoveryservicesvault_tags" {
  type        = map(string)
  description = "The tags for the boot diagnostic storage."
  default = {
    CostCenter = "None"
    Enviroment = "Production"
    Department = "IT"
  }
}