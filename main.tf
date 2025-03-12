locals {
  short_cluster_name = substr(data.aws_eks_cluster.cluster.name, 0, 40)
}

data "harness_platform_current_account" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}
