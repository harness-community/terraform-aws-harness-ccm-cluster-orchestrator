# delegate orchestrator

deploy a harness delegate into an eks cluster and create the nessesary connectors in harness to enable ccm

then create the orchestrator components in aws, the orchestrator resource in harness, and configure the orchestrator

## vpc

tag subnets with the nessesary values for the orchestrator to find them:

```
"harness.io/${cluster name}" = "owned"
```

## eks

tag the clusters node security group with the harness required tags for the orchestrator

```
"harness.io/${cluster name}" = "owned"
```

create a harness delegate token, deploy a delegate using helm, and create a k8s and ccm k8s connector at the account level

## orchestrator

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
| cluster-orchestrator | ../../ | n/a |
| delegate | harness/harness-delegate/kubernetes | 0.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.cluster_node_security_group_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.cluster_subnet_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [harness_platform_connector_kubernetes.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes) | resource |
| [harness_platform_connector_kubernetes_cloud_cost.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes_cloud_cost) | resource |
| [harness_platform_delegatetoken.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_delegatetoken) | resource |
| [helm_release.orchestrator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_groups.cluster_node_security_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_subnets.cluster_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami-type | AMI type to use | `string` | `"AL2_x86_64"` | no |
| cluster\_oidc\_arn | OIDC ARN for the EKS cluster | `string` | n/a | yes |
| eks-cluster-name | EKS cluster name | `string` | n/a | yes |
| eks-cluster-node-security-group-ids | EKS cluster node security group IDs | `list(string)` | n/a | yes |
| eks-version | EKS version to use | `string` | `"1.32"` | no |
| manager\_endpoint | Manager endpoint for the delegate | `string` | `"https://app.harness.io/gratis"` | no |
| subnet\_ids | Subnet IDs | `list(string)` | n/a | yes |
| tags | Tags to apply to the cluster nodes | `map(string)` | `{}` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ccm\_k8s\_connector\_id | CCM Kubernetes Connector ID |
| eks\_cluster\_amis | n/a |
| eks\_cluster\_controller\_role\_arn | n/a |
| eks\_cluster\_default\_instance\_profile | n/a |
| eks\_cluster\_node\_role\_arn | n/a |
| harness\_ccm\_token | n/a |
| harness\_cluster\_orchestrator\_id | n/a |