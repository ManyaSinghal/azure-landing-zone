variable "management_group_display_name" {
  type        = string
  description = "This is Management Group display name"
  default     = ""
}

variable "parent_management_group_id" {
  type        = string
  description = "This is Management Group's parent mg id"
  default     = null
}

variable "subscription_ids" {
  type        = list(any)
  description = "subscription ids attached to mg "
  default     = []
}

variable "management_group_users_for_owner_role" {
  type        = list(any)
  description = "Add user ids to assign owner access on the  management group"
  default     = []
}

variable "management_group_users_for_reader_role" {
  type        = list(any)
  description = "Add user ids to assign reader access on the  management group"
  default     = []
}

variable "management_group_usergroups_for_owner_role" {
  type        = list(any)
  description = "Add user groups to assign owner access on the  management group"
  default     = []
}

variable "management_group_usergroups_for_reader_role" {
  type        = list(any)
  description = "Add user groups to assign reader access on the  management group"
  default     = []
}
