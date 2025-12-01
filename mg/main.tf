variable "environment" {
  description = "Environment name (e.g., DEV, TEST, PROD). Passed from pipeline."
  type        = string
  validation {
    condition     = contains(["DEV", "TEST", "PROD"], upper(var.environment))
    error_message = "environment must be one of: DEV, TEST, or PROD (case-insensitive)."
  }
}

locals {
  json_object                = jsondecode(file("${path.module}/mg.json"))
  tenant_management_group_id = local.json_object.mg_structure.tenant.id
  root_display_name          = "${var.environment} ${local.json_object.company_prefix} ${local.json_object.mg_structure.tenant.root.display_name}"
  root_management_group_id   = lower(replace(local.root_display_name, " ", "-"))
}

module "management_groups" {
  source                     = "../modules/services/management-groups"
  environment                = var.environment
  tenant_management_group_id = local.tenant_management_group_id
  root_display_name          = local.root_display_name
  root_management_group_id   = lower(replace(local.root_display_name, " ", "-"))
}

output "mg_json_object" {
  value = local.json_object
}

output "tenant_management_group_id" {
  value = local.tenant_management_group_id
}

output "root_display_name" {
  value = local.root_display_name
}

output "root_management_group_id" {
  value = local.root_management_group_id
}
