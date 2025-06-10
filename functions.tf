# resource "google_cloudfunctions_function" "function" {
#   count = var.use_functions ? 1 : 0
#
#   name        = "function-test"
#   description = "My function"
#   runtime     = "nodejs16"
#
#   available_memory_mb   = 128
#   source_archive_bucket = google_storage_bucket.bucket.name
#   source_archive_object = google_storage_bucket_object.archive.name
#   trigger_http          = true
#   entry_point           = "helloGET"
# }

