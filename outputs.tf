output "harness_ccm_token" {
  value     = harness_platform_token.api_token.value
  sensitive = true
}

output "eks_cluster_controller_role_arn" {
  value = aws_iam_role.controller_role.arn
}

output "eks_cluster_default_instance_profile" {
  value = aws_iam_instance_profile.instance_profile.name
}

output "eks_cluster_node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "harness_cluster_orchestrator_id" {
  value = harness_cluster_orchestrator.cluster_orchestrator.id
}