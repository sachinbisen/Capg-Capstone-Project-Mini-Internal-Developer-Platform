# Root-level Terraform configuration for shared locals and future module wiring.
# Keeping common tags in one place ensures consistent metadata across resources.

locals {
  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
