variable "name" {
  type        = string
  default     = null
  description = "Name prefix for the cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "eks-version" {
  type        = string
  default     = "1.32"
  description = "EKS version to use"
}

variable "ami-type" {
  type        = string
  default     = "AL2_x86_64"
  description = "AMI type to use"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the cluster nodes"
}

variable "manager_endpoint" {
  type        = string
  default     = "https://app.harness.io/gratis"
  description = "Manager endpoint for the delegate"
}