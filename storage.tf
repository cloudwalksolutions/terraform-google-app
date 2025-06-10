
module "bucket" {
  count = var.create_buckets ? 1 : 0

  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name       = "${local.app_label}-public-content"
  project_id = var.app_project_id
  location   = var.region

  force_destroy = var.force_destroy

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "allUsers"
  }]
}


resource "google_storage_bucket" "backend_bucket" {
  count = var.create_buckets ? 1 : 0

  project       = var.app_project_id
  name          = "${local.app_label}-backend-bucket"
  location      = var.region
  force_destroy = var.lifecycle_name != "prod"

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = false

  cors {
    origin = var.lifecycle_name == "dev" ? ["http://localhost:3000", "https://${local.lifecycle_domain}"] : ["https://${local.lifecycle_domain}"]
    method = ["OPTIONS", "PUT", "GET", "HEAD"]
    response_header = [
      "Accept",
      "Accept-Control-Request-Headers",
      "Accept-Control-Request-Method",
      "Accept-Encoding",
      "Accept-Language",
      "Cache-Control",
      "Content-Range",
      "Content-Type",
      "Content-Length",
      "Origin",
      "Pragma",
      "Referer",
      "Sec-Ch-Ua",
      "Sec-Ch-Ua-Mobile",
      "Sec-Ch-Ua-Platform",
      "Sec-Fetch-Mode",
      "Sec-Fetch-Dest",
      "Sec-Fetch-Site",
      "User-Agent",
      "X-Client-Data",
    ]
    max_age_seconds = var.lifecycle_name == "prod" ? 3600 : 30

  }

}
