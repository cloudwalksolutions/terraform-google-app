
data "google_secret_manager_secret_version" "secrets_data" {
  for_each = var.use_django ? toset(concat(var.secrets_list, [var.django_secret_name])) : toset(var.secrets_list)

  secret  = each.key
  project = var.app_project_id
}

data "google_secret_manager_secret_version" "gmaps_secret" {
  count = var.use_gmaps ? 1 : 0

  secret  = var.gmaps_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "attom_secret" {
  count = var.use_attom ? 1 : 0

  secret  = var.attom_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "infobip_secret" {
  count = var.use_infobip ? 1 : 0

  secret  = var.infobip_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "rapid_api_secret" {
  count = var.use_rapid_api ? 1 : 0

  secret  = var.rapid_api_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "groupme_secret" {
  count = var.use_groupme ? 1 : 0

  secret  = var.groupme_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "jwt_secret" {
  count = var.use_jwt ? 1 : 0

  secret  = var.jwt_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "oauth_secrets" {
  for_each = var.use_google_oauth ? toset(var.oauth_secret_names) : toset([])

  secret  = each.key
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "deepai_secret" {
  count = var.use_deepai ? 1 : 0

  secret  = var.deepai_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "openai_secret" {
  count = var.use_openai ? 1 : 0

  secret  = var.openai_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "sendgrid_secret" {
  count = var.use_sendgrid ? 1 : 0

  secret  = var.sendgrid_secret_name
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "airtable_secrets" {
  for_each = var.use_airtable ? toset(var.airtable_secret_names) : toset([])

  secret  = var.lifecycle_name == "prod" ? each.key : "nonprod-${each.key}"
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "twilio_secrets" {
  for_each = var.use_twilio ? toset(var.twilio_secret_names) : toset([])

  secret  = each.key
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "wiseagent_secrets" {
  for_each = var.use_wiseagent ? toset(var.wiseagent_secret_names) : toset([])

  secret  = each.key
  project = var.app_project_id
}


data "google_secret_manager_secret_version" "twilio_flex_secrets" {
  for_each = var.use_twilio_flex ? toset(var.twilio_flex_secret_names) : toset([])

  secret  = each.key
  project = var.app_project_id
}


