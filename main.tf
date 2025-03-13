locals {
  short_cluster_name = substr(var.cluster_name, 0, 40)
}

data "harness_platform_current_account" "current" {}
