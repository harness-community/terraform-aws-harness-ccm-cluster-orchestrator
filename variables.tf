variable "cluster_name" {
  type        = string
  description = "EKS cluster Name"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_oidc_arn" {
  type        = string
  default     = null
  description = "OIDC Provder ARN for the cluster"
}

variable "cluster_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels"
}

variable "cluster_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels"
}

variable "cluster_amis" {
  type        = list(string)
  default     = []
  description = "AMIs used in your EKS cluster; If passed will be tagged with required orchestrator labels"
}

variable "ccm_k8s_connector_id" {
  type        = string
  description = "harness ccm kubernetes connector for the cluster"
}

variable "node_role_policies" {
  type        = list(string)
  default     = []
  description = "List of IAM policies to attach to the node role"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "Type of AMI to use for the node group"
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Kubernetes version to use for the node group. Required if ami_type is set"
}

variable "cluster_orchestrator_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace Cluster Orchestrator is being installed in"
}

variable "cluster_orchestrator_service_account" {
  type        = string
  default     = "ccm-cluster-orchestrator-operator"
  description = "Kubernetes service account used by the Cluster Orchestrator Operator component"
}

variable "use_eks_pod_identity" {
  type        = bool
  default     = false
  description = "If EKS Pod Identity should be used for IAM as opposed to IRSA"
}
