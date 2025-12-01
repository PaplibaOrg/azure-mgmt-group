variable "mg_config" {
  description = "Management group configuration loaded from mg.auto.tfvars.json"
  type        = any
}

locals {
  # Normalize environment and prefixes
  env_lower = lower(var.mg_config.environment)

  mg_prefix = env_lower == "prod" ? var.mg_config.company_prefix : "${env_lower}-${var.mg_config.company_prefix}"

  display_name_prefix  = title(var.mg_config.environment)
  company_display_name = title(var.mg_config.company_prefix)

  # Build tenant root dynamically
  tenant_root = {
    name         = "${local.mg_prefix}-root"
    display_name = "${local.display_name_prefix} ${local.company_display_name} ${var.mg_config.root_display_name}"
  }

  # Build first level hierarchy dynamically
  first_level_hierarchy = {
    for key, value in var.mg_config.first_level_hierarchy :
    key => {
      name         = "${local.mg_prefix}-${key}"
      display_name = value.display_name
    }
  }

  # Build second level hierarchy dynamically
  second_hierarchy = {
    platform = {
      for key, value in var.mg_config.first_level_hierarchy.platform.second_hierarchy :
      key => {
        name         = "${local.mg_prefix}-${key}"
        display_name = value.display_name
      }
    }
    landingzones = {
      for key, value in var.mg_config.first_level_hierarchy.landingzones.second_hierarchy :
      key => {
        name         = "${local.mg_prefix}-${key}"
        display_name = value.display_name
      }
    }
  }
}

module "management_groups" {
  source = "../modules/services/management-groups"

  mg_prefix             = local.mg_prefix
  company_prefix        = var.mg_config.company_prefix
  tenant_root_group_id  = var.mg_config.tenant_root_group_id
  environment           = var.mg_config.environment
  tenant_root           = local.tenant_root
  first_level_hierarchy = local.first_level_hierarchy
  second_hierarchy      = local.second_hierarchy
}