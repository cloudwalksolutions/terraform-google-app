
resource "google_dns_managed_zone" "dns_zone" {
  count = local.lifecycle_name == "ops" && var.create_dns_zone ? 1 : 0

  project = var.dns_project_id

  name     = local.app_dns_zone
  dns_name = "${var.domain}."
  dnssec_config {
    state = "on"
  }
}


resource "google_compute_global_address" "global_ip" {
  count = var.create_ip && !var.disabled ? 1 : 0

  project = var.gke_project_id
  name    = local.ip_name
}


resource "google_dns_record_set" "dns_record_set" {
  count = var.create_ip && var.create_record_set && !var.disabled ? 1 : 0

  project = var.dns_project_id

  managed_zone = local.app_dns_zone
  name         = local.final_domain
  type         = "A"
  rrdatas      = [google_compute_global_address.global_ip[0].address]
  ttl          = 86400

  depends_on = [
    google_dns_managed_zone.dns_zone,
    google_compute_global_address.global_ip,
  ]
}

