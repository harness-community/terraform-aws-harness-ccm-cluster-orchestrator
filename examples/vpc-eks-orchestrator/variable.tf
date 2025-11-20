variable "name" {
  type        = string
  default     = null
  description = "Name prefix for the cluster"
}

variable "eks-version" {
  type        = string
  default     = "1.32"
  description = "EKS version to use"
}

variable "ami-type" {
  type        = string
  default     = "AL2023_ARM_64_STANDARD"
  description = "AMI type to use"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the cluster nodes"
}