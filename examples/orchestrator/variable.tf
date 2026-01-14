variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_cluster_node_security_group_ids" {
  type        = list(string)
  description = "EKS cluster node security group IDs"
}

variable "eks_version" {
  type        = string
  default     = "1.32"
  description = "EKS version to use"
}

variable "cluster_oidc_arn" {
  type        = string
  description = "OIDC ARN for the EKS cluster"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "AMI type to use"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the cluster nodes"
}

variable "ccm_k8s_connector_id" {
  type        = string
  description = "CCM k8s connector ID"
}
