locals {
  # Read all .tfvr.json files in the current directory
  json_object_map = {
    for file in fileset(path.module, "*.tfvr.json") :
    replace(file, ".tfvr.json", "") => jsondecode(file("${path.module}/${file}"))
  }
}

module "management_groups" {
  source = "../modules/services/management-groups"

  for_each = local.json_object_map

  mg_prefix            = each.value.mg_prefix
  tenant_root_group_id = each.value.tenant_root_group_id
  environment          = each.value.environment
  sequence             = each.value.sequence
  location             = each.value.location
  subscription_ids     = lookup(each.value, "subscription_ids", [])
  tags                 = lookup(each.value, "tags", {})
}
