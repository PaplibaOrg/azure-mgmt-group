# variable "mg_prefix" {
#   description = "Full prefix for management group names (e.g., 'dev-PLB', 'test-PLB', 'PLB')."
#   type        = string
# }

# variable "company_prefix" {
#   description = "Company shorthand prefix (e.g., 'PLB'). Must be uppercase and less than 4 characters."
#   type        = string

#   validation {
#     condition     = var.company_prefix == upper(var.company_prefix) && length(var.company_prefix) < 4
#     error_message = "company_prefix must be uppercase and less than 4 characters (e.g., 'PLB')."
#   }
# }

# variable "environment" {
#   description = "Environment name. Only DEV, TEST, and PROD are allowed."
#   type        = string

#   validation {
#     condition     = contains(["DEV", "TEST", "PROD"], upper(var.environment))
#     error_message = "environment must be one of: DEV, TEST, PROD."
#   }
# }

variable "tenant" {
  description = "Tenant root management group configuration"
  type = object({
    management_group_id = string
  })
}

variable "root" {
  description = "Environment root management group configuration"
  type = object({
    display_name = string
  })
}

# variable "first_level_hierarchy" {
#   description = "First level hierarchy management groups"
#   type = object({
#     platform = object({
#       name         = string
#       display_name = string
#     })
#     landingzones = object({
#       name         = string
#       display_name = string
#     })
#     sandbox = object({
#       name         = string
#       display_name = string
#     })
#     decommissioned = object({
#       name         = string
#       display_name = string
#     })
#   })
# }

# variable "second_hierarchy" {
#   description = "Second level hierarchy management groups"
#   type = object({
#     platform = object({
#       management = object({
#         name         = string
#         display_name = string
#       })
#       connectivity = object({
#         name         = string
#         display_name = string
#       })
#       identity = object({
#         name         = string
#         display_name = string
#       })
#       security = object({
#         name         = string
#         display_name = string
#       })
#     })
#     landingzones = object({
#       corp = object({
#         name         = string
#         display_name = string
#       })
#       online = object({
#         name         = string
#         display_name = string
#       })
#     })
#   })
# }


