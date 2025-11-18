module "cluster-orchestrator" {
  source = "git::https://github.com/harness-community/terraform-aws-harness-ccm-cluster-orchestrator.git?ref=main"

  cluster_name     = data.aws_eks_cluster.this.name
  cluster_endpoint = data.aws_eks_cluster.this.endpoint
  cluster_oidc_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.this.identity.oidc.issuer).last}"

  ami_type           = ami_type
  cluster_amis       = cluster_amis
  kubernetes_version = data.aws_eks_cluster.this.version

  cluster_subnet_ids         = data.aws_eks_cluster.this.vpc_config.subnet_ids
  cluster_security_group_ids = set(concat(data.aws_eks_cluster.this.vpc_config.cluster_security_group_id, data.aws_eks_cluster.this.vpc_config.security_group_ids))

  ccm_k8s_connector_id = var.ccm_k8s_connector_id
}

resource "harness_cluster_orchestrator_config" "orchestrator" {
  orchestrator_id = module.cluster-orchestrator.harness_cluster_orchestrator_id
  distribution {
    ondemand_replica_percentage = 0.0
    selector                    = "ALL"
    strategy                    = "CostOptimized"
  }
}

resource "helm_release" "orchestrator" {
  name             = "harness-ccm-cluster-orchestrator"
  repository       = "https://lightwing-downloads.s3.ap-southeast-1.amazonaws.com/cluster-orchestrator-helm-chart"
  chart            = "harness-ccm-cluster-orchestrator"
  namespace        = "kube-system"
  create_namespace = false

  values = [yamlencode({
    harness = {
      accountID      = data.harness_platform_current_account.current.id
      k8sConnectorID = var.ccm_k8s_connector_id
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
}