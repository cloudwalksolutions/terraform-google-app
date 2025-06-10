
resource "helm_release" "app" {
  count = !var.disabled && var.use_helm ? 1 : 0

  repository = "https://${var.app_chart_repo}"
  chart      = var.chart_name
  version    = var.chart_version

  name             = local.namespace
  namespace        = local.namespace
  create_namespace = true
  reuse_values     = true
  wait             = false

  values = [
    "${file("${var.chart_values_path}/values.yaml")}",
    "${file("${var.chart_values_path}/${local.lifecycle_name}.yaml")}",
  ]

  set {
    name  = "app_code"
    value = var.app_code
  }

  set {
    name  = "lifecycle"
    value = local.lifecycle_name
  }

  set {
    name  = "domain"
    value = local.full_domain
  }

  set {
    name  = "gke_project_id"
    value = var.gke_project_id
  }

  set {
    name  = "db_project_id"
    value = var.db_project_id
  }

  set {
    name  = "google.storage.bucket_name"
    value = "${local.app_label}-backend-bucket"
  }

  set {
    name  = "google.key"
    value = var.use_django
  }

  set {
    name  = "oauth.google.enabled"
    value = var.use_google_oauth
  }

  set {
    name  = "ingress.bring_ip"
    value = var.create_ip
  }

  set {
    name  = "ip_name"
    value = google_compute_global_address.global_ip[0].name
  }

  set {
    name  = "external_dns.enabled"
    value = !var.create_record_set
  }

  set {
    name  = "external_secrets.enabled"
    value = !var.create_k8s_secrets
  }

  set {
    name  = "wiseagent.enabled"
    value = var.use_wiseagent
  }

  set {
    name  = "attom.enabled"
    value = var.use_attom
  }

  set {
    name  = "openai.enabled"
    value = var.use_openai
  }

  set {
    name  = "crm.enabled"
    value = var.use_crm
  }

  depends_on = [
    google_compute_global_address.global_ip,
  ]

}

