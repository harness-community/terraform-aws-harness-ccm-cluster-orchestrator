# orchestrator

set up the orchestrator against an eks cluster which has already been deployed and bootstrapped with a harness delegate and connectors

## orchestrator

`orchestrator.tf`

deploy the orchestrator into the cluster using helm

configure the cluster for 100% spot usage

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 6.0 |
| harness | ~> 0.0 |
| helm | ~> 2.17 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 6.0 |
| harness | ~> 0.0 |
| helm | ~> 2.17 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cluster-orchestrator | git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git | main |

## Resources

| Name | Type |
|------|------|
| [harness_cluster_orchestrator_config.orchestrator](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/cluster_orchestrator_config) | resource |
| [helm_release.orchestrator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_type | The AMI type to use for the cluster. Required if cluster\_amis is not set | `string` | `null` | no |
| ccm\_k8s\_connector\_id | The Harness CCM Kubernetes connector ID for this cluster | `string` | n/a | yes |
| cluster\_amis | The AMIs to use for the cluster. Required if ami\_type is not set | `list(string)` | `null` | no |
| cluster\_name | The target EKS cluster name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eks\_cluster\_amis | n/a |
| eks\_cluster\_controller\_role\_arn | n/a |
| eks\_cluster\_default\_instance\_profile | n/a |
| eks\_cluster\_node\_role\_arn | n/a |
| harness\_ccm\_token | n/a |
| harness\_cluster\_orchestrator\_id | n/a |