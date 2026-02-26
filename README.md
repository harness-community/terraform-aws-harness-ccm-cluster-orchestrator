# terraform-aws-harness-ccm-cluster-orchestrator

terraform module to provision AWS and Harness resources for enabling cluster orchestrator on an eks cluster

## Getting started

you will need the following components before you deploy the cluster orchestrator:

- a vpc and eks cluster, with an oidc provider created and the metrics-server installed
- a harness delegate deployed in the cluster, along with a kubernetes and ccm kubernetes connector created at the account level

once the above are created, this module provisioned, you will be ready to [deploy the orchestrator using helm](https://developer.harness.io/docs/cloud-cost-management/use-ccm-cost-optimization/cluster-orchestrator/enablement-methods/setting-up-co-helm#step-3-install-the-cluster-orchestrator)

based on what you already have deployed there are a set of `examples/` to help you get started

If you have:
- nothing
  - [examples/vpc-eks-delegate-orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/vpc-eks-delegate-orchestrator)
- a vpc
  - [examples/eks-delegate-orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/eks-delegate-orchestrator)
- a vpc and eks cluster
  - [examples/delegate-orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/delegate-orchestrator)
- a vpc, eks cluster, a delegate and connectors (which are usually deployed together)
  - [examples/orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/orchestrator)

set up the [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) and [harness](https://registry.terraform.io/providers/harness/harness/latest/docs) provider

### In-Line Values

the following is an example of using the module with hard coded values, this illustrates the typical values expected

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
  ami_type = "AL2_x86_64"
  kubernetes_version = "1.32"
  ccm_k8s_connector_id = "dev-ccm"
}
```

you can opt to pre-tag your subnets and security groups with the required labels for the cluster orchestrator to function, and then omit the `cluster_subnet_ids` and `cluster_security_group_ids` arguments

if you want to use a specific AMI rather than the EKS default for the specific kubernetes version, you can do so with `cluster_amis`

### Using VPC+EKS Module (recommended)

if you are provisioning your cluster with terraform, it is best practice to include this module in the same project. below is an example of referncing existing terraform resources for inputs to the module:

```
module "cluster-orchestrator" {
  source = "git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git"

  cluster_name               = module.eks.cluster_name
  cluster_endpoint           = module.eks.cluster_endpoint
  cluster_oidc_arn           = module.eks.oidc_provider_arn
  cluster_subnet_ids         = module.vpc.private_subnets
  cluster_security_group_ids = [module.eks.node_security_group_id]
  ami_type                   = "AL2_x86_64"
  kubernetes_version         = module.eks.cluster_version
  ccm_k8s_connector_id       = "dev-ccm"
}
```

### Use EKS Pod Identity instead of IRSA

If you would like to use [EKS Pod Identity](https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html) as opposed to IRSA for providing IAM permissions, simply set `use_eks_pod_identity` to `true`. This does require you have the EKS Pod Identity Agent configured in your EKS cluster. If you don't have an EKS cluster, the following examples will install the agent along with other add-ons:

- [examples/vpc-eks-delegate-orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/vpc-eks-delegate-orchestrator)
- [examples/eks-delegate-orchestrator](https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator/tree/main/examples/eks-delegate-orchestrator)

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
| [aws_iam_role_policy_attachment.controller_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_eks_pod_identity_association.controller_roleaws_iam_role_policy_attachment.node_role](https://registry.terraform.io/providers/-/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [harness_cluster_orchestrator.cluster_orchestrator](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/cluster_orchestrator) | resource |
| [harness_platform_apikey.api_key](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_apikey) | resource |
| [harness_platform_role_assignments.cluster_orch_role](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_role_assignments) | resource |
| [harness_platform_service_account.cluster_orch_service_account](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_service_account) | resource |
| [harness_platform_token.api_token](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_token) | resource |
| [aws_iam_policy_document.assume_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.controller_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_type | Type of AMI to use for the node group | `string` | `"AL2_x86_64"` | no |
| ccm\_k8s\_connector\_id | harness ccm kubernetes connector for the cluster | `string` | n/a | yes |
| cluster\_amis | AMIs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| cluster\_endpoint | EKS cluster endpoint | `string` | n/a | yes |
| cluster\_name | EKS cluster Name | `string` | n/a | yes |
| cluster\_oidc\_arn | OIDC Provder ARN for the cluster | `string` | n/a | yes |
| cluster\_security\_group\_ids | Security group IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| cluster\_subnet\_ids | Subnet IDs used in your EKS cluster; If passed will be tagged with required orchestrator labels | `list(string)` | `[]` | no |
| kubernetes\_version | Kubernetes version to use for the node group. Required if ami\_type is set | `string` | `null` | no |
| cluster\_orchestrator\_namespace | Kubernetes namespace Cluster Orchestrator is being installed in | `string` | `kube-system` | no |
| cluster\_orchestrator\_service\_account | Kubernetes service account used by the Cluster Orchestrator Operator component | `string` | `ccm-cluster-orchestrator-operator` | no |
| use\_eks\_pod\_identity | If EKS Pod Identity should be used for IAM as opposed to IRSA | `bool` | `false` | no |
| node\_role\_policies | List of IAM policies to attach to the node role | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| eks\_cluster\_amis | n/a |
| eks\_cluster\_controller\_role\_arn | n/a |
| eks\_cluster\_default\_instance\_profile | n/a |
| eks\_cluster\_node\_role\_arn | n/a |
| harness\_ccm\_token | n/a |
| harness\_cluster\_orchestrator\_id | n/a |
