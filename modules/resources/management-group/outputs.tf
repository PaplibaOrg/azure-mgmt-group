output "management_group_id" {
  description = "The ID of the management group"
  value       = azurerm_management_group.this.id
}

output "management_group_name" {
  description = "The name of the management group"
  value       = azurerm_management_group.this.name
}

output "management_group_display_name" {
  description = "The display name of the management group"
  value       = azurerm_management_group.this.display_name
}
