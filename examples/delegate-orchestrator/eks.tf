data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

#   - tag the cluster security group with the harness required tags for the orchestrator
data "aws_security_groups" "cluster_node_security_groups" {
  filter {
    name   = "group-name"
    values = var.eks_cluster_node_security_group_ids
  }
}

resource "aws_ec2_tag" "cluster_node_security_group_tag" {
  for_each    = toset(data.aws_security_groups.cluster_node_security_groups.ids)
  resource_id = each.value
  key         = format("harness.io/%s", substr(data.aws_eks_cluster.this.name, 0, 40))
  value       = "owned"
}

# deploy a harness delegate into the cluster
resource "harness_platform_delegatetoken" "eks" {
  name       = "eks-${data.aws_eks_cluster.this.name}"
  account_id = data.harness_platform_current_account.current.id
}

module "delegate" {
  source  = "harness/harness-delegate/kubernetes"
  version = "0.2.3"

  account_id       = data.harness_platform_current_account.current.id
  delegate_token   = harness_platform_delegatetoken.eks.value
  delegate_name    = data.aws_eks_cluster.this.name
  deploy_mode      = "KUBERNETES"
  namespace        = "harness-delegate-ng"
  manager_endpoint = var.manager_endpoint
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.10.86901"
  replicas         = 1
  upgrader_enabled = true
}

# create the harness k8s connectors
resource "harness_platform_connector_kubernetes" "eks" {
  identifier = "eks_${replace(data.aws_eks_cluster.this.name, "-", "_")}"
  name       = "eks-${data.aws_eks_cluster.this.name}"

  inherit_from_delegate {
    delegate_selectors = [data.aws_eks_cluster.this.name]
  }
}

resource "harness_platform_connector_kubernetes_cloud_cost" "eks" {
  identifier = "eks_${replace(data.aws_eks_cluster.this.name, "-", "_")}_ccm"
  name       = "eks-${data.aws_eks_cluster.this.name}-ccm"

  features_enabled = ["VISIBILITY", "OPTIMIZATION"]
  connector_ref    = harness_platform_connector_kubernetes.eks.id
}
