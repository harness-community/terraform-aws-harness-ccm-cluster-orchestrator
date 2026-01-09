# create the orchestrator components in aws and harness
module "cluster-orchestrator" {
  source = "../../"
  # source = "git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git?ref=main"

  cluster_name     = data.aws_eks_cluster.this.name
  cluster_endpoint = data.aws_eks_cluster.this.endpoint
  cluster_oidc_arn = var.cluster_oidc_arn

  ami_type           = var.ami-type
  kubernetes_version = var.eks-version

  ccm_k8s_connector_id = harness_platform_connector_kubernetes_cloud_cost.eks.id
}

# define your specific settings for how the orchestrator should run
# currently broken - fix ccm-
# resource "harness_cluster_orchestrator_config" "orchestrator" {
#   orchestrator_id = module.cluster-orchestrator.harness_cluster_orchestrator_id
#   distribution {
#     ondemand_replica_percentage = 0.0
#     selector                    = "ALL"
#     strategy                    = "CostOptimized"
#   }
# }

# deploy the orchestrator into the cluster
resource "helm_release" "orchestrator" {
  name             = "harness-ccm-cluster-orchestrator"
  repository       = "https://lightwing-downloads.s3.ap-southeast-1.amazonaws.com/cluster-orchestrator-helm-chart"
  chart            = "harness-ccm-cluster-orchestrator"
  namespace        = "kube-system"
  create_namespace = false

  values = [yamlencode({
    harness = {
      accountID      = data.harness_platform_current_account.current.id
      k8sConnectorID = harness_platform_connector_kubernetes_cloud_cost.eks.id
    }
    eksCluster = {
      name              = data.aws_eks_cluster.this.name
      region            = data.aws_region.current.region
      controllerRoleARN = module.cluster-orchestrator.eks_cluster_controller_role_arn
      endpoint          = data.aws_eks_cluster.this.endpoint
      defaultInstanceProfile = {
        name = module.cluster-orchestrator.eks_cluster_default_instance_profile
      }
      nodeRole = {
        arn = module.cluster-orchestrator.eks_cluster_node_role_arn
      }
    }
    clusterOrchestrator = {
      id = module.cluster-orchestrator.harness_cluster_orchestrator_id
      image = {
        tag = "alpha-0.5.2.1"
      }
    }
  })]

  set_sensitive {
    name  = "harness.ccm.secret.token"
    value = module.cluster-orchestrator.harness_ccm_token
    type  = "string"
  }

  depends_on = [module.delegate]
}