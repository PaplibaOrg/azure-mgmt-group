variable "mg_prefix" {
  description = "Prefix for management group names (e.g., 'dev-plb', 'test-plb', 'plb')"
  type        = string
}

variable "tenant_root_group_id" {
  description = "The tenant root management group ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "sequence" {
  description = "Sequence number for naming"
  type        = string
  default     = "001"
}

variable "location" {
  description = "Azure region (not used for MGs but kept for consistency)"
  type        = string
  default     = "eastus"
}

variable "subscription_ids" {
  description = "List of subscription IDs to assign to the root management group"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all management groups"
  type        = map(string)
  default     = {}
}
