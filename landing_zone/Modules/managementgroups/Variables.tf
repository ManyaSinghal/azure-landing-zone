variable "mainmanagement_group1_display_name" {
  type        = string
  description = "This is Main Management Group display name"
}

variable "management_group1_display_name" {
  type        = string
  description = "This is First Management Group display name"
}

variable "management_group1_subscription_ids" {
  type        = list(any)
  description = "This is First Management Group's list of Subscription Ids"
}

variable "management_group2_display_name" {
  type        = string
  description = "This is Second Management Group display name"
}

variable "management_group2_subscription_ids" {
  type        = list(any)
  description = "This is Second Management Group's list of Subscription Ids"
}

variable "management_group2a_display_name" {
  type        = string
  description = "This is 2a Management Group display name"
}

variable "management_group2a_subscription_ids" {
  type        = list(any)
  description = "This is 2a Management Group's list of Subscription Ids"
}

variable "management_group2b_display_name" {
  type        = string
  description = "This is 2b Management Group display name"
}

variable "management_group2b_subscription_ids" {
  type        = list(any)
  description = "This is 2b Management Group's list of Subscription Ids"
}

variable "management_group3_display_name" {
  type        = string
  description = "This is Third Management Group display name"
}

variable "management_group3_subscription_ids" {
  type        = list(any)
  description = "This is Third Management Group's list of Subscription Ids"
}

variable "management_group4_display_name" {
  type        = string
  description = "This is Fourth Management Group display name"
}

variable "management_group4_subscription_ids" {
  type        = list(any)
  description = "This is Fourth Management Group's list of Subscription Ids"
}

variable "mainmanagement_group_users_for_owner_role" {
  type        = list(any)
  description = "Add user ids to assign owner access on the main management group"
}

variable "mainmanagement_group_users_for_reader_role" {
  type        = list(any)
  description = "Add user ids to assign reader access on the main management group"
}

variable "mainmanagement_group_usergroups_for_owner_role" {
  type        = list(any)
  description = "Add user groups to assign owner access on the main management group"
}

variable "mainmanagement_group_usergroups_for_reader_role" {
  type        = list(any)
  description = "Add user groups to assign reader access on the main management group"
}