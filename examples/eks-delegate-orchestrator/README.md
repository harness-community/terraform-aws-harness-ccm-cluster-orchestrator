# vpc eks delegateorchestrator

deploy a new eks cluster using aws modules bootrstrapped with a harness delegate and connectors

then create the orchestrator components in aws, the orchestrator resource in harness, and configure the orchestrator

this will need to be done in two parts, saving the helm install for the delegate and orchestrator until after the cluster is created

this can be done with opentofu's -exclude option:
```
tofu apply -exclude="helm_release.orchestrator" -exclude="module.delegate.helm_release.delegate"
```

then a full apply can be done:
```
tofu apply
```

## vpc

tag subnets with the nessesary values for the orchestrator to find them:

```
"harness.io/${cluster name}" = "owned"
```

## eks

`eks.tf`

provision an EKS cluster with a single dedicated node to run the orchestrator and delegate

create a harness delegate token, deploy a delegate using helm, and create a k8s and ccm k8s connector at the account level

a basic cluster, to run a few add-ons, the delegate, and the orchestrator components has the following resource needs:
```
│   cpu      1350m (34%)   2 (51%)       │
│   memory   2188Mi (14%)  4536Mi (30%)  │
```

we can use a single t4g.medium ($30/mo on-demand) node to run dedicated components, this combined with the $70 base cost of EKS gives our cluster a total cost of $100/mo before workloads are provisioned

if we were to use fargate pods for the delegate and orchestrator the cost would be x2 a single t3.medium ($0.068/hr)

| Comp     | CPU        | MEM         | Size   | Fargate Cost |
|----------|------------|-------------|--------|--------------|
| Delegate | 0.04048/hr | 0.004445/hr | 1x4    | 0.05826/hr   |
| Orch     | 0.04048/hr | 0.004445/hr | .25x.5 | 0.0123425/hr |
|          |            |             |        |              |
| Total    |            |             |        | 0.0706025/hr |

adding a taint to the default dedicated nodepool and corresponding toleration to the orchestrator and delegate (along with addones) will allow the system componenets to run on this node while workloads run on compute provisioned by the orchestrator

```
tolerations:
- key: "compute"
  operator: "Equal"
  value: "dedicated"
  effect: "NoSchedule"
```

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
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cluster-orchestrator | ../../ | n/a |
| delegate | harness/harness-delegate/kubernetes | 0.2.3 |
| eks | terraform-aws-modules/eks/aws | = 21.8.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.cluster_subnet_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [harness_platform_connector_kubernetes.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes) | resource |
| [harness_platform_connector_kubernetes_cloud_cost.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_connector_kubernetes_cloud_cost) | resource |
| [harness_platform_delegatetoken.eks](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_delegatetoken) | resource |
| [helm_release.orchestrator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.cluster_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami-type | AMI type to use | `string` | `"AL2_x86_64"` | no |
| eks-version | EKS version to use | `string` | `"1.32"` | no |
| manager\_endpoint | Manager endpoint for the delegate | `string` | `"https://app.harness.io/gratis"` | no |
| name | Name prefix for the cluster | `string` | `null` | no |
| subnet\_ids | Subnet IDs | `list(string)` | n/a | yes |
| tags | Tags to apply to the cluster nodes | `map(string)` | `{}` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

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