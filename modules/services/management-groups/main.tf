locals {
  # Build hierarchy from JSON structure
  tenant_root  = var.tenant_root
  first_level  = var.first_level_hierarchy
  second_level = var.second_hierarchy

  # Flatten first level hierarchy for for_each
  first_level_mgs = {
    platform       = local.first_level.platform
    landingzones   = local.first_level.landingzones
    sandbox        = local.first_level.sandbox
    decommissioned = local.first_level.decommissioned
  }

  # Flatten second level hierarchy for for_each
  # Platform children
  platform_children = {
    management   = local.second_level.platform.management
    connectivity = local.second_level.platform.connectivity
    identity     = local.second_level.platform.identity
    security     = local.second_level.platform.security
  }

  # Landing zones children
  landingzones_children = {
    corp   = local.second_level.landingzones.corp
    online = local.second_level.landingzones.online
  }

  # Combine all second level MGs with their parent key
  second_level_mgs = merge(
    {
      for key, value in local.platform_children :
      "platform-${key}" => {
        mg_config  = value
        parent_key = "platform"
      }
    },
    {
      for key, value in local.landingzones_children :
      "landingzones-${key}" => {
        mg_config  = value
        parent_key = "landingzones"
      }
    }
  )
}

# Root Management Group
module "root_mg" {
  source                     = "../../resources/management-group"
  name                       = local.tenant_root.name
  display_name               = local.tenant_root.display_name
  parent_management_group_id = var.tenant_root_group_id
}

# First Level Hierarchy - Create all first-level MGs
module "first_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = local.first_level_mgs
  name                       = each.value.name
  display_name               = each.value.display_name
  parent_management_group_id = module.root_mg.management_group_id
  depends_on                 = [module.root_mg]
}

# Second Level Hierarchy - Create all second-level MGs
module "second_level_mgs" {
  source                     = "../../resources/management-group"
  for_each                   = local.second_level_mgs
  name                       = each.value.mg_config.name
  display_name               = each.value.mg_config.display_name
  parent_management_group_id = module.first_level_mgs[each.value.parent_key].management_group_id
  depends_on                 = [module.first_level_mgs]
}
