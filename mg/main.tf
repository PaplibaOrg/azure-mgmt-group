variable "tenant_root_group_id" {
  description = "Tenant root management group ID (from mg.auto.tfvars.json)"
  type        = string
}

variable "company_prefix" {
  description = "Company prefix (e.g., 'PLB') loaded from mg.auto.tfvars.json"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., DEV, TEST, PROD) loaded from mg.auto.tfvars.json"
  type        = string
}

variable "root_display_name" {
  description = "Root management group display name from mg.auto.tfvars.json"
  type        = string
}

variable "first_level_hierarchy" {
  description = "First level hierarchy configuration from mg.auto.tfvars.json"
  type        = any
}

locals {
  # Normalize environment and prefixes
  env_lower = lower(var.environment)

  mg_prefix = env_lower == "prod" ? var.company_prefix : "${env_lower}-${var.company_prefix}"

  display_name_prefix  = title(var.environment)
  company_display_name = title(var.company_prefix)

  # Build tenant root dynamically
  tenant_root = {
    name         = "${local.mg_prefix}-root"
    display_name = "${local.display_name_prefix} ${local.company_display_name} ${var.root_display_name}"
  }

  # Build first level hierarchy dynamically
  first_level_hierarchy = {
    for key, value in var.first_level_hierarchy :
    key => {
      name         = "${local.mg_prefix}-${key}"
      display_name = value.display_name
    }
  }

  # Build second level hierarchy dynamically
  second_hierarchy = {
    platform = {
      for key, value in var.first_level_hierarchy.platform.second_hierarchy :
      key => {
        name         = "${local.mg_prefix}-${key}"
        display_name = value.display_name
      }
    }
    landingzones = {
      for key, value in var.first_level_hierarchy.landingzones.second_hierarchy :
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
  company_prefix        = var.company_prefix
  tenant_root_group_id  = var.tenant_root_group_id
  environment           = var.environment
  tenant_root           = local.tenant_root
  first_level_hierarchy = local.first_level_hierarchy
  second_hierarchy      = local.second_hierarchy
}