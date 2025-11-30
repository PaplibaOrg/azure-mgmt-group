variable "name" {
  description = "The name of the management group"
  type        = string
}

variable "display_name" {
  description = "The display name of the management group"
  type        = string
}

variable "parent_management_group_id" {
  description = "The ID of the parent management group"
  type        = string
}

variable "subscription_ids" {
  description = "List of subscription IDs to assign to this management group"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the management group"
  type        = map(string)
  default     = {}
}
