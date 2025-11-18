data "harness_platform_current_account" "current" {}

data "aws_region" "current" {}

resource "random_pet" "name" {
  prefix = var.name
}

locals {
  name      = random_pet.name.id
  safe_name = replace(random_pet.name.id, "-", "_")
}

output "name" {
  description = "Name"
  value       = local.name
}