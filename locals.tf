

locals {
  lifecycle_name = var.lifecycle_name == "main" ? "prod" : var.lifecycle_name

  location = var.regional ? var.region : var.zone

  namespace = "${local.lifecycle_name}-${var.app_code}"

  app_label = var.label == "" ? local.namespace : "${local.namespace}-${var.label}"

  lifecycle_letter = substr(local.lifecycle_name, 0, 1)

  force_destroy = local.lifecycle_name == "prod" ? false : var.force_destroy

  ip_name = "${local.app_label}-ip"

  cicd_service_account = "projects/${var.app_project_id}/serviceAccounts/${local.namespace}-cicd@${var.app_project_id}.iam.gserviceaccount.com"

  basic_build_image = "gcr.io/cloud-builders/docker:latest"

  kaniko_build_image = "gcr.io/kaniko-project/executor:${var.kaniko_version}"
  kaniko_extra_args = var.cicd_cache_enabled ? concat(var.kaniko_extra_args, [
    "--cache=true",
    "--cache-ttl=720h"
  ]) : var.kaniko_extra_args

  cicd_build_image = var.use_kaniko ? local.kaniko_build_image : local.basic_build_image

  registry_id     = "${local.app_label}-images"
  registry_prefix = var.create_registry ? "${var.region}-docker.pkg.dev" : "gcr.io"

  images_to_push = flatten([for location in var.build_locations : [
    "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${location}:latest",
    "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${location}:$COMMIT_SHA",
  ]])

  full_domain      = var.subdomain != "" ? "${var.subdomain}.${var.domain}" : var.domain
  lifecycle_domain = local.lifecycle_name == "prod" ? "${local.full_domain}" : "${local.lifecycle_name}.${local.full_domain}"
  final_domain     = "${local.lifecycle_domain}."

  app_dns_zone = var.dns_zone_name != "" ? var.dns_zone_name : "${var.app_code}-dns-zone"

  initial_app_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.secrets_data : key => val.secret_data
  }

  oauth_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.oauth_secrets : key => val.secret_data
  }

  gmaps_secret_map = {
    (var.gmaps_secret_name) = var.use_gmaps ? data.google_secret_manager_secret_version.gmaps_secret[0].secret_data : ""
  }

  jwt_secret_map = {
    (var.jwt_secret_name) = var.use_jwt ? data.google_secret_manager_secret_version.jwt_secret[0].secret_data : ""
  }

  sendgrid_secret_map = {
    (var.sendgrid_secret_name) = var.use_sendgrid ? data.google_secret_manager_secret_version.sendgrid_secret[0].secret_data : ""
  }

  deepai_secret_map = {
    (var.deepai_secret_name) = var.use_deepai ? data.google_secret_manager_secret_version.deepai_secret[0].secret_data : ""
  }

  openai_secret_map = {
    (var.openai_secret_name) = var.use_openai ? data.google_secret_manager_secret_version.openai_secret[0].secret_data : ""
  }

  airtable_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.airtable_secrets : key => val.secret_data
  }

  twilio_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.twilio_secrets : key => val.secret_data
  }

  twilio_flex_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.twilio_flex_secrets : key => val.secret_data
  }

  attom_secret_map = {
    (var.attom_secret_name) = var.use_attom ? data.google_secret_manager_secret_version.attom_secret[0].secret_data : ""
  }

  groupme_secret_map = {
    (var.groupme_secret_name) = var.use_groupme ? data.google_secret_manager_secret_version.groupme_secret[0].secret_data : ""
  }

  rapid_api_secret_map = {
    (var.rapid_api_secret_name) = var.use_rapid_api ? data.google_secret_manager_secret_version.rapid_api_secret[0].secret_data : ""
  }

  infobip_secret_map = {
    (var.infobip_secret_name) = var.use_infobip ? data.google_secret_manager_secret_version.infobip_secret[0].secret_data : ""
  }

  wiseagent_secrets_map = {
    for key, val in data.google_secret_manager_secret_version.wiseagent_secrets : key => val.secret_data
  }

  app_secrets_map = merge(
    local.initial_app_secrets_map, local.oauth_secrets_map, local.gmaps_secret_map, local.attom_secret_map, local.groupme_secret_map,
    local.sendgrid_secret_map, local.airtable_secrets_map, local.twilio_secrets_map, local.deepai_secret_map, local.infobip_secret_map,
    local.twilio_flex_secrets_map, local.wiseagent_secrets_map, local.jwt_secret_map, local.openai_secret_map, local.rapid_api_secret_map
  )
}


