# create the cluster
#   - tag the cluster security group with the harness required tags for the orchestrator
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "= 21.8.0"

  name               = local.name
  kubernetes_version = var.eks_version

  endpoint_public_access = true

  addons = {
    metrics-server = {
      configuration_values = jsonencode({
        tolerations : [
          {
            effect : "NoSchedule",
            key : "compute",
            operator : "Equal",
            value : "dedicated"
          }
        ]
      })
    }
    coredns = {
      configuration_values = jsonencode({
        tolerations : [
          {
            effect : "NoSchedule",
            key : "compute",
            operator : "Equal",
            value : "dedicated"
          }
        ]
      })
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute              = true
      resolve_conflicts_on_create = "OVERWRITE"
      addon_version               = "v1.20.4-eksbuild.1"
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      name = substr(local.name, 0, 20)

      ami_type = var.ami_type

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      taints = {
        compute = {
          key    = "compute"
          value  = "dedicated"
          effect = "NO_SCHEDULE"
        }
      }

      tags = var.tags
    }
  }

  # for ccm cluster orchestrator
  node_security_group_tags = {
    "harness.io/${local.name}" = "owned"
  }
}

# deploy a harness delegate into the cluster
resource "harness_platform_delegatetoken" "eks" {
  name       = "eks-${local.name}"
  account_id = data.harness_platform_current_account.current.id
}

module "delegate" {
  source  = "harness/harness-delegate/kubernetes"
  version = "0.2.3"

  account_id       = data.harness_platform_current_account.current.id
  delegate_token   = harness_platform_delegatetoken.eks.value
  delegate_name    = local.name
  deploy_mode      = "KUBERNETES"
  namespace        = "harness-delegate-ng"
  manager_endpoint = var.manager_endpoint
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.10.86901"
  replicas         = 1
  upgrader_enabled = true

  values = <<EOF
    tags: "orchestrator,aws,eks"
    tolerations:
    - key: "compute"
      operator: "Equal"
      value: "dedicated"
      effect: "NoSchedule"
EOF

  depends_on = [module.eks]
}

# create the harness k8s connectors
resource "harness_platform_connector_kubernetes" "eks" {
  identifier = "eks_${local.safe_name}"
  name       = "eks-${local.name}"

  inherit_from_delegate {
    delegate_selectors = [local.name]
  }
}

resource "harness_platform_connector_kubernetes_cloud_cost" "eks" {
  identifier = "eks_${local.safe_name}_ccm"
  name       = "eks-${local.name}-ccm"

  features_enabled = ["VISIBILITY", "OPTIMIZATION"]
  connector_ref    = harness_platform_connector_kubernetes.eks.id
}
