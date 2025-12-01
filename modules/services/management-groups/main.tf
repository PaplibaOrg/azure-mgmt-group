module "root_mg" {
  source                     = "../../resources/management-group"
  parent_management_group_id = var.tenant_management_group_id
  display_name               = "${var.environment} ${var.company_prefix} ${var.root_management_group_display_name}"
  id                         = lower("${var.environment}-${var.company_prefix}-${var.root_management_group_display_name}")
}

module "first_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = var.first_level_hierarchy
  display_name               = each.value.display_name
  id                         = lower("${var.environment}-${each.key}")
  parent_management_group_id = module.root_mg.management_group_id
  depends_on                 = [module.root_mg]
}

# Flatten second_level_hierarchy for for_each
locals {
  second_level_mgs = merge([
    for parent_key, children in var.second_level_hierarchy : {
      for child_key, child_value in children :
      "${parent_key}-${child_key}" => {
        parent_key   = parent_key
        display_name = child_value.display_name
      }
    }
  ]...)
}

# Second Level Hierarchy - Create all second-level MGs
module "second_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = local.second_level_mgs
  display_name               = each.value.display_name
  id                         = lower("${var.environment}-${each.key}")
  parent_management_group_id = module.first_level_mgs[each.value.parent_key].management_group_id
  depends_on                 = [module.first_level_mgs]
}
