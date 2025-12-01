module "root_mg" {
  source                     = "../../resources/management-group"
  parent_management_group_id = var.tenant_management_group_id
  display_name               = "${var.environment} ${var.company_prefix} ${var.root_management_group_display_name}"
  id                         = lower("${var.environment}-${var.company_prefix}-${var.root_management_group_display_name}")
}

module "first_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = var.first_level_hierarchy
  display_name               = "${var.environment} ${each.value.display_name}"
  id                         = lower("${var.environment}-${each.key}")
  parent_management_group_id = module.root_mg.management_group_id
  depends_on                 = [module.root_mg]
}

# # Second Level Hierarchy - Create all second-level MGs
# module "second_level_mgs" {
#   source                     = "../../resources/management-group"
#   for_each                   = local.second_level_mgs
#   name                       = each.value.mg_config.name
#   display_name               = each.value.mg_config.display_name
#   parent_management_group_id = module.first_level_mgs[each.value.parent_key].management_group_id
#   depends_on                 = [module.first_level_mgs]
# }
