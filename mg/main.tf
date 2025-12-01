locals {
  mg_config = jsondecode(file("${path.module}/mg.json"))
}

# module "management_groups" {
#   source = "../modules/services/management-groups"

#   mg_prefix             = local.mg_prefix
#   company_prefix        = local.mg_config.company_prefix
#   tenant_root_group_id  = local.mg_config.tenant_root_group_id
#   environment           = local.mg_config.environment
#   tenant_root           = local.tenant_root
#   first_level_hierarchy = local.first_level_hierarchy
#   second_hierarchy      = local.second_hierarchy
# }

output "print" {
  value       = local.mg_config
}