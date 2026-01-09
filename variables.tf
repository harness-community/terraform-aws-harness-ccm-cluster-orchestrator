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

variable "eks_pod_identity" {
  type        = bool
  default     = false
  description = "Enable EKS pod identity"
}

variable "enable_eks_pod_identity_addon" {
  type        = bool
  default     = false
  description = "Enable EKS pod identity addon"
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
