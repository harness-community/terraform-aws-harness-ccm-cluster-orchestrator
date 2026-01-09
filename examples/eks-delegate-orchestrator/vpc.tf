data "aws_subnets" "cluster_subnets" {
  filter {
    name   = "tag:Name"
    values = var.subnet_ids
  }
}

resource "aws_ec2_tag" "cluster_subnet_tag" {
  for_each    = toset(data.aws_subnets.cluster_subnets.ids)
  resource_id = each.value
  key         = format("harness.io/%s", local.name)
  value       = "owned"
}