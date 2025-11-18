variable "cluster_name" {
  type        = string
  description = "The target EKS cluster name"
}

variable "ami_type" {
  type        = string
  description = "The AMI type to use for the cluster. Required if cluster_amis is not set"
  default     = null
}

variable "cluster_amis" {
  type        = list(string)
  description = "The AMIs to use for the cluster. Required if ami_type is not set"
  default     = null
}

variable "ccm_k8s_connector_id" {
  type        = string
  description = "The Harness CCM Kubernetes connector ID for this cluster"
}
