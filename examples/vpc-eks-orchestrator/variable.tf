variable "name" {
  type    = string
  default = null
}

variable "eks-version" {
  type    = string
  default = "1.32"
}

variable "ami-type" {
  type    = string
  default = "AL2023_ARM_64_STANDARD"
}

variable "tags" {
  type    = map(string)
  default = {}
}