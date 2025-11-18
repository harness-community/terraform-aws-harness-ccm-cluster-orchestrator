data "harness_platform_current_account" "current" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

locals {
  cluster_id = split("/", split("/", data.aws_eks_cluster.this.endpoint)[0])[-1]
}

data "aws_iam_openid_connect_provider" "this" {
  arn = var.cluster_oidc_arn
}
