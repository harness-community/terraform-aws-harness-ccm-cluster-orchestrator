data "harness_platform_current_account" "current" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}
