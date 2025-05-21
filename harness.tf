resource "harness_cluster_orchestrator" "cluster_orchestrator" {
  name             = local.short_cluster_name
  cluster_endpoint = var.cluster_endpoint
  k8s_connector_id = var.ccm_k8s_connector_id
}

resource "harness_platform_service_account" "cluster_orch_service_account" {
  identifier  = replace(local.short_cluster_name, "-", "_")
  name        = local.short_cluster_name
  email       = format("%s-%s-%s@service.harness.io", "harness-ccm", local.short_cluster_name, "controller")
  description = "service account for cluster orchestrator"
  account_id  = data.harness_platform_current_account.current.id
}

resource "harness_platform_role_assignments" "cluster_orch_role" {
  resource_group_identifier = "_all_account_level_resources"
  role_identifier           = "_account_admin"
  principal {
    identifier = harness_platform_service_account.cluster_orch_service_account.id
    type       = "SERVICE_ACCOUNT"
  }
}

resource "harness_platform_apikey" "api_key" {
  identifier  = replace(local.short_cluster_name, "-", "_")
  name        = local.short_cluster_name
  parent_id   = harness_platform_service_account.cluster_orch_service_account.id
  apikey_type = "SERVICE_ACCOUNT"
  account_id  = data.harness_platform_current_account.current.id

  lifecycle {
    ignore_changes = [
      default_time_to_expire_token
    ]
  }
}

resource "harness_platform_token" "api_token" {
  identifier  = "token"
  name        = replace(local.short_cluster_name, "-", "_")
  parent_id   = harness_platform_service_account.cluster_orch_service_account.id
  account_id  = data.harness_platform_current_account.current.id
  apikey_type = "SERVICE_ACCOUNT"
  apikey_id   = harness_platform_apikey.api_key.id
}
