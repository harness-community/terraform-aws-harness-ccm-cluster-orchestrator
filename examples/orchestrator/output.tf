output "harness_ccm_token" {
  value     = module.cluster-orchestrator.harness_ccm_token
  sensitive = true
}

output "eks_cluster_controller_role_arn" {
  value = module.cluster-orchestrator.eks_cluster_controller_role_arn
}

output "eks_cluster_default_instance_profile" {
  value = module.cluster-orchestrator.eks_cluster_default_instance_profile
}

output "eks_cluster_node_role_arn" {
  value = module.cluster-orchestrator.eks_cluster_node_role_arn
}

output "harness_cluster_orchestrator_id" {
  value = module.cluster-orchestrator.harness_cluster_orchestrator_id
}

output "eks_cluster_amis" {
  value = module.cluster-orchestrator.eks_cluster_amis
}