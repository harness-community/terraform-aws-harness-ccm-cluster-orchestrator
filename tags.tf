resource "aws_ec2_tag" "cluster_subnet_tag" {
  for_each    = toset(var.cluster_subnet_ids)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}

resource "aws_ec2_tag" "cluster_security_group_tag" {
  for_each    = toset(var.cluster_security_group_ids)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}

resource "aws_ec2_tag" "cluster_ami_tag" {
  for_each    = toset(var.cluster_amis)
  resource_id = each.value
  key         = format("harness.io/%s", local.short_cluster_name)
  value       = "owned"
}