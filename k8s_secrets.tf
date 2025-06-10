
resource "kubernetes_secret" "app_secrets" {
  count = !var.disabled && var.create_k8s_secrets ? 1 : 0

  metadata {
    name      = "app-secrets"
    namespace = local.namespace
  }

  type = "Opaque"

  data = local.app_secrets_map

  depends_on = [
    helm_release.app,
  ]
}


resource "kubernetes_secret" "json_creds" {
  count = !var.disabled && var.create_k8s_secrets && var.use_django ? 1 : 0

  metadata {
    name      = "json-credentials"
    namespace = local.namespace
  }

  type = "Opaque"

  data = {
    "credentials.json" = base64decode(google_service_account_key.key[0].private_key)
  }

  depends_on = [
    helm_release.app,
  ]
}


resource "kubernetes_secret" "oauth_creds" {
  count = !var.disabled && var.create_k8s_secrets && var.use_google_oauth ? 1 : 0

  metadata {
    name      = "oauth-credentials"
    namespace = local.namespace
  }

  type = "Opaque"

  data = {
    "client_id"     = lookup(data.google_secret_manager_secret_version.oauth_secrets, var.oauth_secret_names[0], {}).secret_data
    "client_secret" = lookup(data.google_secret_manager_secret_version.oauth_secrets, var.oauth_secret_names[1], {}).secret_data
  }

  depends_on = [
    helm_release.app,
  ]
}

