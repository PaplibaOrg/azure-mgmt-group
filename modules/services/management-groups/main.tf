locals {
  # For PROD, don't include environment prefix in names/IDs
  is_prod = upper(var.environment) == "PROD"
  
  # Root MG naming
  root_display_name = local.is_prod ? "${var.company_prefix} ${var.root_management_group_display_name}" : "${var.environment} ${var.company_prefix} ${var.root_management_group_display_name}"
  root_id           = local.is_prod ? lower("${var.company_prefix}-${var.root_management_group_display_name}") : lower("${var.environment}-${var.company_prefix}-${var.root_management_group_display_name}")
  
  # Flatten second_level_hierarchy for for_each
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

module "root_mg" {
  source                     = "../../resources/management-group"
  parent_management_group_id = var.tenant_management_group_id
  display_name               = local.root_display_name
  id                         = local.root_id
}

module "first_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = var.first_level_hierarchy
  display_name               = local.is_prod ? each.value.display_name : "${var.environment} ${each.value.display_name}"
  id                         = local.is_prod ? lower(each.key) : lower("${var.environment}-${each.key}")
  parent_management_group_id = module.root_mg.management_group_id
  depends_on                 = [module.root_mg]
}

# Second Level Hierarchy - Create all second-level MGs
module "second_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = local.second_level_mgs
  display_name               = local.is_prod ? each.value.display_name : "${var.environment} ${each.value.display_name}"
  id                         = local.is_prod ? lower(each.key) : lower("${var.environment}-${each.key}")
  parent_management_group_id = module.first_level_mgs[each.value.parent_key].management_group_id
  depends_on                 = [module.first_level_mgs]
}



