variable "environment" {
  description = "Environment name (e.g., dev, test, prod). Passed from pipeline."
  type        = string
}

locals {
  # Load full management group configuration from JSON
  mg_config = jsondecode(file("${path.module}/mg.json"))
}

# In future we will pass environment down to the service module:
# module "management_groups" {
#   source      = "../modules/services/management-groups"
#   environment = var.environment
#   ...
# }

output "print" {
  value = local.mg_config
}