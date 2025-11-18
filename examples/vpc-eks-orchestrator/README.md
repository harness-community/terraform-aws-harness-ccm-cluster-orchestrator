# vpc eks orchestrator

deploy a new vpc and eks cluster using aws modules bootrstrapped with a harness delegate and connectors

then create the orchestrator components in aws, the cluster and harness

## vpc

`vpc.tf`

provision a vpc with public and private subnets

## eks

`eks.tf`

provision an EKS cluster with a single dedicated node to run the orchestrator and delegate

create a harness delegate token, deploy a delegate using helm, and create a k8s and ccm k8s connector at the account level

a basic cluster, to run a few add-ons, the delegate, and the orchestrator components has the following resource needs:
```
│   cpu      1350m (34%)   2 (51%)       │
│   memory   2188Mi (14%)  4536Mi (30%)  │
```

we can use a single t4g.medium ($25/mo on-demand, $15/mo reserved) node to run dedicated components

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
| aws | 6.21.0 |
| harness | 0.39.2 |
| helm | 2.17.0 |
| random | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cluster-orchestrator | git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git | main |
| delegate | harness/harness-delegate/kubernetes | 0.2.3 |
| eks | terraform-aws-modules/eks/aws | = 21.8.0 |
| fck-nat | RaJiska/fck-nat/aws | n/a |
| vpc | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [harness_cluster_orchestrator_config.orchestrator](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/cluster_orchestrator_config) | resource |
| [harness_platform_connector_kubernetes.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes) | resource |
| [harness_platform_connector_kubernetes_cloud_cost.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes_cloud_cost) | resource |
| [harness_platform_delegatetoken.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_delegatetoken) | resource |
| [helm_release.orchestrator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami-type | n/a | `string` | `"AL2023_ARM_64_STANDARD"` | no |
| eks-version | n/a | `string` | `"1.32"` | no |
| name | n/a | `string` | `null` | no |
| tags | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ccm\_k8s\_connector\_id | CCM Kubernetes Connector ID |
| cluster\_endpoint | Cluster Endpoint |
| cluster\_id | Cluster ID |
| eks\_cluster\_amis | n/a |
| eks\_cluster\_controller\_role\_arn | n/a |
| eks\_cluster\_default\_instance\_profile | n/a |
| eks\_cluster\_node\_role\_arn | n/a |
| harness\_ccm\_token | n/a |
| harness\_cluster\_orchestrator\_id | n/a |
| name | Name |
| private\_subnets | Private Subnets |
| public\_subnets | Public Subnets |
| vpc\_id | VPC ID |