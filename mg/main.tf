variable "environment" {
  description = "Environment name (e.g., DEV, TEST, PROD). Passed from pipeline."
  type        = string
  validation {
    condition     = contains(["DEV", "TEST", "PROD"], upper(var.environment))
    error_message = "environment must be one of: DEV, TEST, or PROD (case-insensitive)."
  }
}

locals {
  json_object = jsondecode(file("${path.module}/mg.json"))
}

module "management_groups" {
  source                             = "../modules/services/management-groups"
  company_prefix                     = local.json_object.company_prefix
  environment                        = var.environment
  tenant_management_group_id         = local.json_object.mg_structure.tenant.id
  root_management_group_display_name = local.json_object.mg_structure.tenant.root.display_name
  first_level_hierarchy              = local.json_object.mg_structure.tenant.root.first_level_hierarchy
}

output "mg_json_object" {
  value = local.json_object
}

output "first_level_hierarchy" {
  value = local.json_object.mg_structure.tenant.root.first_level_hierarchy
}
