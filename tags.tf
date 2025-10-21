resource "aws_ec2_tag" "cluster_subnet_tag" {
  for_each    = toset(var.cluster_subnet_ids)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}

resource "aws_ec2_tag" "cluster_security_group_tag" {
  for_each    = toset(var.cluster_security_group_ids)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}

# locate AMI based on latest for type and cluster version
# source - aws eks module https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/modules/eks-managed-node-group/main.tf#L395-L421
locals {
  # Map the AMI type to the respective SSM param path
  ssm_ami_type_to_ssm_param = {
    AL2_x86_64                 = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2/recommended/image_id"
    AL2_x86_64_GPU             = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2-gpu/recommended/image_id"
    AL2_ARM_64                 = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2-arm64/recommended/image_id"
    CUSTOM                     = "NONE"
    BOTTLEROCKET_ARM_64        = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}/arm64/latest/image_id"
    BOTTLEROCKET_x86_64        = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}/x86_64/latest/image_id"
    BOTTLEROCKET_ARM_64_FIPS   = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}-fips/arm64/latest/image_id"
    BOTTLEROCKET_x86_64_FIPS   = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}-fips/x86_64/latest/image_id"
    BOTTLEROCKET_ARM_64_NVIDIA = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}-nvidia/arm64/latest/image_id"
    BOTTLEROCKET_x86_64_NVIDIA = "/aws/service/bottlerocket/aws-k8s-${var.kubernetes_version}-nvidia/x86_64/latest/image_id"
    WINDOWS_CORE_2019_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-${var.kubernetes_version}"
    WINDOWS_FULL_2019_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-${var.kubernetes_version}"
    WINDOWS_CORE_2022_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-${var.kubernetes_version}"
    WINDOWS_FULL_2022_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-${var.kubernetes_version}"
    AL2023_x86_64_STANDARD     = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
    AL2023_ARM_64_STANDARD     = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/arm64/standard/recommended/image_id"
    AL2023_x86_64_NEURON       = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/x86_64/neuron/recommended/image_id"
    AL2023_x86_64_NVIDIA       = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/x86_64/nvidia/recommended/image_id"
    AL2023_ARM_64_NVIDIA       = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/arm64/nvidia/recommended/image_id"
  }

  latest_amis = var.ami_type != null ? startswith(var.ami_type, "WINDOWS") ? [nonsensitive(jsondecode(data.aws_ssm_parameter.ami[0].value)["release_version"])] : [nonsensitive(data.aws_ssm_parameter.ami[0].value)] : []
  amis_to_tag = concat(var.cluster_amis, local.latest_amis)
}

data "aws_ssm_parameter" "ami" {
  count = var.ami_type != null ? 1 : 0

  region = data.aws_region.current.region

  name = local.ssm_ami_type_to_ssm_param[var.ami_type]
}

resource "aws_ec2_tag" "cluster_ami_tag" {
  for_each    = toset(local.amis_to_tag)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}