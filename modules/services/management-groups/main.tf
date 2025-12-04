locals {
  # For PROD, don't include environment prefix in names/IDs
  is_prod = upper(var.environment) == "PROD"
  
  # Construct root MG ID based on naming convention
  root_mg_name = local.is_prod ? lower("${var.company_prefix}-${var.root_management_group_display_name}") : lower("${var.environment}-${var.company_prefix}-${var.root_management_group_display_name}")
  root_management_group_id = "/providers/Microsoft.Management/managementGroups/${local.root_mg_name}"
  
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

module "first_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = var.first_level_hierarchy
  display_name               = each.value.display_name
  id                         = local.is_prod ? lower(each.key) : lower("${var.environment}-${each.key}")
  parent_management_group_id = local.root_management_group_id
}

# Second Level Hierarchy - Create all second-level MGs
module "second_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = local.second_level_mgs
  display_name               = each.value.display_name
  id                         = local.is_prod ? lower(each.key) : lower("${var.environment}-${each.key}")
  parent_management_group_id = module.first_level_mgs[each.value.parent_key].management_group_id
  depends_on                 = [module.first_level_mgs]
}



