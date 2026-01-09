resource "aws_eks_addon" "pod-identity-agent" {
  count        = var.enable_eks_pod_identity_addon ? 1 : 0
  cluster_name = var.cluster_name
  addon_name   = "eks-pod-identity-agent"
}