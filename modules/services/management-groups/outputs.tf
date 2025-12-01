output "root_mg_id" {
  description = "The ID of the root management group"
  value       = module.root_mg.management_group_id
}

output "first_level_mg_ids" {
  description = "Map of first level management group IDs"
  value = {
    for key, mg in module.first_level_mgs :
    key => mg.management_group_id
  }
}

output "second_level_mg_ids" {
  description = "Map of second level management group IDs"
  value = {
    for key, mg in module.second_level_mgs :
    key => mg.management_group_id
  }
}

# Individual outputs for backward compatibility
output "platform_mg_id" {
  description = "The ID of the platform management group"
  value       = module.first_level_mgs["platform"].management_group_id
}

output "landingzones_mg_id" {
  description = "The ID of the landing zones management group"
  value       = module.first_level_mgs["landingzones"].management_group_id
}

output "sandbox_mg_id" {
  description = "The ID of the sandbox management group"
  value       = module.first_level_mgs["sandbox"].management_group_id
}

output "decommissioned_mg_id" {
  description = "The ID of the decommissioned management group"
  value       = module.first_level_mgs["decommissioned"].management_group_id
}

output "management_mg_id" {
  description = "The ID of the management management group"
  value       = module.second_level_mgs["platform-management"].management_group_id
}

output "connectivity_mg_id" {
  description = "The ID of the connectivity management group"
  value       = module.second_level_mgs["platform-connectivity"].management_group_id
}

output "identity_mg_id" {
  description = "The ID of the identity management group"
  value       = module.second_level_mgs["platform-identity"].management_group_id
}

output "security_mg_id" {
  description = "The ID of the security management group"
  value       = module.second_level_mgs["platform-security"].management_group_id
}

output "corp_mg_id" {
  description = "The ID of the corp management group"
  value       = module.second_level_mgs["landingzones-corp"].management_group_id
}

output "online_mg_id" {
  description = "The ID of the online management group"
  value       = module.second_level_mgs["landingzones-online"].management_group_id
}
