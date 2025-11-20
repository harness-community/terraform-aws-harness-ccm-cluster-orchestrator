data "aws_iam_policy_document" "assume_inline_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "node_role" {
  name               = format("%s-%s-%s", "harness-ccm", local.short_cluster_name, "node")
  assume_role_policy = data.aws_iam_policy_document.assume_inline_policy.json
  description        = format("%s %s %s", "Role to manage", var.cluster_name, "EKS cluster used by Harness CCM")
}

resource "aws_iam_role_policy_attachment" "node_role" {
  for_each   = toset(concat(["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"], var.node_role_policies))
  role       = aws_iam_role.node_role.name
  policy_arn = each.key
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = format("%s-%s-%s", "harness-ccm", local.short_cluster_name, "inst-prof")
  role = aws_iam_role.node_role.name
}

resource "aws_iam_policy" "controller_role_policy" {
  name = format("%s-%s", local.short_cluster_name, "ClusterOrchController")
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter",
          "pricing:GetProducts",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeImages",
          "ec2:GetSpotPlacementScores",
          "eks:DescribeCluster"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

data "aws_iam_policy_document" "controller_trust_policy" {
  statement {
    actions = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        var.cluster_oidc_arn
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "controller_role" {
  name               = format("%s-%s-%s", "harness-ccm", local.short_cluster_name, "controller")
  assume_role_policy = data.aws_iam_policy_document.controller_trust_policy.json
  description        = format("%s %s %s", "Role to manage", var.cluster_name, "EKS cluster controller used by Harness CCM")
}

resource "aws_iam_role_policy_attachment" "controller_role" {
  role       = aws_iam_role.controller_role.name
  policy_arn = aws_iam_policy.controller_role_policy.arn
}
