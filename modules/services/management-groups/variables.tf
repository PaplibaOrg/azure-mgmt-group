variable "company_prefix" {
  description = "Company shorthand prefix (e.g., 'PLB'). Must be uppercase and less than 4 characters."
  type        = string

  validation {
    condition     = var.company_prefix == upper(var.company_prefix) && length(var.company_prefix) < 4
    error_message = "company_prefix must be uppercase and less than 4 characters (e.g., 'PLB')."
  }
}

variable "environment" {
  description = "Environment name. Only DEV, TEST, and PROD are allowed."
  type        = string

  validation {
    condition     = contains(["DEV", "TEST", "PROD"], upper(var.environment))
    error_message = "environment must be one of: DEV, TEST, PROD."
  }
}

variable "tenant_management_group_id" {
  description = "Tenant root management group ID"
  type        = string
}

variable "root_management_group_display_name" {
  description = "Environment root management group display name"
  type        = string
}

variable "first_level_hierarchy" {
  description = "First level hierarchy management groups as a JSON object (e.g., { platform = { display_name = \"Platform\" }, ... })."
  type = map(object({
    display_name = string
  }))
}

variable "second_level_hierarchy" {
  description = "Second level hierarchy management groups as a nested JSON object (e.g., { platform = { management = { display_name = \"Management\" } }, ... })."
  type = map(map(object({
    display_name = string
  })))
  default = {}
}



