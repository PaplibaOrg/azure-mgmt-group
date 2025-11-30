locals {
  # Define the CAF hierarchy structure
  mg_hierarchy = {
    root = {
      name         = "${var.mg_prefix}-root"
      display_name = "${title(var.mg_prefix)} Root"
      parent_id    = var.tenant_root_group_id
    }
    platform = {
      name         = "${var.mg_prefix}-platform"
      display_name = "Platform"
      parent_id    = module.root_mg.management_group_id
    }
    landingzones = {
      name         = "${var.mg_prefix}-landingzones"
      display_name = "Landing Zones"
      parent_id    = module.root_mg.management_group_id
    }
    sandbox = {
      name         = "${var.mg_prefix}-sandbox"
      display_name = "Sandbox"
      parent_id    = module.root_mg.management_group_id
    }
    decommissioned = {
      name         = "${var.mg_prefix}-decommissioned"
      display_name = "Decommissioned"
      parent_id    = module.root_mg.management_group_id
    }
    # Platform children
    management = {
      name         = "${var.mg_prefix}-management"
      display_name = "Management"
      parent_id    = module.platform_mg.management_group_id
    }
    connectivity = {
      name         = "${var.mg_prefix}-connectivity"
      display_name = "Connectivity"
      parent_id    = module.platform_mg.management_group_id
    }
    identity = {
      name         = "${var.mg_prefix}-identity"
      display_name = "Identity"
      parent_id    = module.platform_mg.management_group_id
    }
    security = {
      name         = "${var.mg_prefix}-security"
      display_name = "Security"
      parent_id    = module.platform_mg.management_group_id
    }
    # Landing Zones children
    corp = {
      name         = "${var.mg_prefix}-corp"
      display_name = "Corp"
      parent_id    = module.landingzones_mg.management_group_id
    }
    online = {
      name         = "${var.mg_prefix}-online"
      display_name = "Online"
      parent_id    = module.landingzones_mg.management_group_id
    }
  }

  tags = merge(
    {
      environment = var.environment
      managedBy   = "terraform"
    },
    var.tags
  )
}

# Root Management Group
module "root_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.root.name
  display_name               = local.mg_hierarchy.root.display_name
  parent_management_group_id = local.mg_hierarchy.root.parent_id
  subscription_ids           = var.subscription_ids
  tags                       = local.tags
}

# Platform Management Group
module "platform_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.platform.name
  display_name               = local.mg_hierarchy.platform.display_name
  parent_management_group_id = local.mg_hierarchy.platform.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.root_mg]
}

# Landing Zones Management Group
module "landingzones_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.landingzones.name
  display_name               = local.mg_hierarchy.landingzones.display_name
  parent_management_group_id = local.mg_hierarchy.landingzones.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.root_mg]
}

# Sandbox Management Group
module "sandbox_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.sandbox.name
  display_name               = local.mg_hierarchy.sandbox.display_name
  parent_management_group_id = local.mg_hierarchy.sandbox.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.root_mg]
}

# Decommissioned Management Group
module "decommissioned_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.decommissioned.name
  display_name               = local.mg_hierarchy.decommissioned.display_name
  parent_management_group_id = local.mg_hierarchy.decommissioned.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.root_mg]
}

# Platform Children
module "management_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.management.name
  display_name               = local.mg_hierarchy.management.display_name
  parent_management_group_id = local.mg_hierarchy.management.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.platform_mg]
}

module "connectivity_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.connectivity.name
  display_name               = local.mg_hierarchy.connectivity.display_name
  parent_management_group_id = local.mg_hierarchy.connectivity.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.platform_mg]
}

module "identity_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.identity.name
  display_name               = local.mg_hierarchy.identity.display_name
  parent_management_group_id = local.mg_hierarchy.identity.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.platform_mg]
}

module "security_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.security.name
  display_name               = local.mg_hierarchy.security.display_name
  parent_management_group_id = local.mg_hierarchy.security.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.platform_mg]
}

# Landing Zones Children
module "corp_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.corp.name
  display_name               = local.mg_hierarchy.corp.display_name
  parent_management_group_id = local.mg_hierarchy.corp.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.landingzones_mg]
}

module "online_mg" {
  source = "../../resources/management-group"

  name                       = local.mg_hierarchy.online.name
  display_name               = local.mg_hierarchy.online.display_name
  parent_management_group_id = local.mg_hierarchy.online.parent_id
  subscription_ids           = []
  tags                       = local.tags

  depends_on = [module.landingzones_mg]
}
