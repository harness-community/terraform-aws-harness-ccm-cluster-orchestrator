# terraform-aws-harness-ccm-cluster-orchestrator

terraform module to provision resources related to harness ccm cluster orchestrator

## Example

### In-Line Values

```
module "cluster-orchestrator" {
  source = "git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git"

  cluster_name       = "dev"
  cluster_endpoint   = "https://example-cluster-endpoint.amazonaws.com"
  cluster_oidc_arn   = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
  cluster_subnet_ids = [
    "subnet-12345678"
  ]
  cluster_security_group_ids = [
    "sg-12345678"
  ]
  cluster_amis = [
    "ami-12345678"
  ]
  ccm_k8s_connector_id = "dev-ccm"
}
```

### Using VPC+EKS Module

If you provision your VPC and EKS using the AWS provided TF modules, you can directly reference their outputs:

```
module "cluster-orchestrator" {
  source = "git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git"

  cluster_name               = module.eks.cluster_name
  cluster_endpoint           = module.eks.cluster_endpoint
  cluster_oidc_arn           = module.eks.oidc_provider_arn
  cluster_subnet_ids         = module.vpc.private_subnets
  cluster_security_group_ids = module.eks.node_security_group_id
  cluster_amis = [
    "ami-12345678"
  ]
  ccm_k8s_connector_id = "dev-ccm"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.0 |
| aws | >= 4.16 |
| harness | >= 0.34.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.16 |
| harness | >= 0.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.cluster_ami_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.cluster_security_group_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.cluster_subnet_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.controller_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.controller_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [harness_cluster_orchestrator.cluster_orchestrator](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/cluster_orchestrator) | resource |
| [harness_platform_apikey.api_key](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_apikey) | resource |
| [harness_platform_role_assignments.cluster_orch_role](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_role_assignments) | resource |
| [harness_platform_service_account.cluster_orch_service_account](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_service_account) | resource |
| [harness_platform_token.api_token](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_token) | resource |
| [aws_iam_policy_document.assume_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.controller_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ccm\_k8s\_connector\_id | harness ccm kubernetes connector for the cluster | `string` | n/a | yes |
| cluster\_amis | AMIs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| cluster\_endpoint | EKS cluster endpoint | `string` | n/a | yes |
| cluster\_name | EKS cluster Name | `string` | n/a | yes |
| cluster\_oidc\_arn | OIDC Provder ARN for the cluster | `string` | n/a | yes |
| cluster\_security\_group\_ids | Security group IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| cluster\_subnet\_ids | Subnet IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| node\_role\_policies | List of IAM policies to attach to the node role | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| eks\_cluster\_controller\_role\_arn | n/a |
| eks\_cluster\_default\_instance\_profile | n/a |
| eks\_cluster\_node\_role\_arn | n/a |
| harness\_ccm\_token | n/a |
| harness\_cluster\_orchestrator\_id | n/a |
