terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.16"
    }
    harness = {
      source  = "harness/harness"
      version = ">= 0.34.0"
    }
  }

  required_version = ">= 1.2.0"
}