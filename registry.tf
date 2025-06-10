
resource "google_artifact_registry_repository" "docker_repos" {
  count = var.create_registry ? 1 : 0

  provider = google-beta

  project = var.app_project_id

  location      = var.region
  repository_id = local.registry_id
  format        = "DOCKER"
}



