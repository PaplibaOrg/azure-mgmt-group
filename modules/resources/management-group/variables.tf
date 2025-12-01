variable "name" {
  description = "The name of the management group"
  type        = string
}

variable "display_name" {
  description = "The display name of the management group"
  type        = string
}

variable "parent_management_group_id" {
  description = "The ID of the parent management group (from tenant root or parent resource)"
  type        = string
}
