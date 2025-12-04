output "management_group_id" {
  description = "The ID of the management group"
  value       = azurerm_management_group.mg.id
}

output "management_group_name" {
  description = "The name of the management group"
  value       = azurerm_management_group.mg.name
}

output "management_group_display_name" {
  description = "The display name of the management group"
  value       = azurerm_management_group.mg.display_name
}



