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
