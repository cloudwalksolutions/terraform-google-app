

variable "label" {
  description = "App label"
  type        = string
  default     = ""
}


variable "service_account" {
  description = "Service account used for the workload"
  type        = string
  default     = ""
}


variable "app_code" {
  description = "App team code"
  type        = string
  default     = ""
}


variable "lifecycle_name" {
  description = "Lifecycle name"
  type        = string
}


variable "repo_name" {
  description = "Name of application code repo in Github"
  type        = string
}


variable "domain" {
  description = "DNS Domain"
  type        = string
}


variable "subdomain" {
  description = "DNS sub Domain"
  type        = string
  default     = ""
}


variable "gke_project_id" {
  description = "GKE project ID"
  type        = string
}


variable "db_project_id" {
  description = "Database project ID"
  type        = string
}


variable "dns_project_id" {
  description = "DNS project ID"
  type        = string
}


variable "app_project_id" {
  description = "App project ID"
  type        = string
}


variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "central-cluster"
}


variable "failover_cluster_name" {
  description = "Failover GKE cluster name"
  type        = string
  default     = "east-cluster"
}


variable "github_owner" {
  description = "Github repo owner"
  type        = string
  default     = "theboarderline"
}


variable "admin_email" {
  description = "App Admin email"
  type        = string
  default     = "wnobrien@lakegames.us"
}


variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}


variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}


variable "failover_region" {
  description = "GCP failover region"
  type        = string
  default     = "us-east4"
}


variable "failover_zone" {
  description = "GCP failover zone"
  type        = string
  default     = "us-east4-b"
}


variable "create_dns_zone" {
  description = "Whether Cloud DNS zone should get created"
  type        = bool
  default     = false
}


variable "create_record_set" {
  description = "Whether Cloud DNS record set should get created"
  type        = bool
  default     = false
}


variable "dns_zone_name" {
  description = "Cloud DNS Zone name"
  type        = string
  default     = "dns-zone"
}


variable "included_files" {
  description = "List of included files for cloudbuild"
  type        = list(string)
  default     = ["src/**"]
}


variable "ignored_files" {
  description = "List of ignored files for cloudbuild"
  type        = list(string)
  default     = ["src/mobile/**"]
}


variable "build_locations" {
  description = "List of directories to attach CI trigger to"
  type        = list(string)
  default = [
    "react",
    "api",
  ]
}


variable "namespaces" {
  description = "List of namespaces to make monitoring dashboards for"
  type        = list(string)
  default     = []
}


variable "regional" {
  description = "Whether cluster deploying to is regional (true) or zonal (false)"
  type        = bool
  default     = false
}


variable "create_ip" {
  description = "Whether external IP and DNS A record should get created"
  type        = bool
  default     = false
}


variable "disabled" {
  description = "Whether CICD should be disabled and IP address deleted"
  type        = string
  default     = false
}


variable "force_destroy" {
  description = "Whether storage buckets should get destroyed even if there are objects within"
  type        = bool
  default     = true
}


variable "use_infobip" {
  description = "Whether Infobip API key should be available to application"
  type        = bool
  default     = false
}


variable "infobip_secret_name" {
  description = "Name of Infobip API key secret in secret manager"
  type        = string
  default     = "infobip-api-key"
}


variable "use_helm" {
  description = "Whether CICD should be deploy using helm or not"
  type        = bool
  default     = true
}


variable "cicd_machine_type" {
  description = "Cloudbuild VM machine type"
  type        = string
  default     = ""
}


variable "logging" {
  description = "GCP Bucket Admin"
  type        = string
  default     = "LEGACY"
}


variable "trigger_timeout" {
  description = "Cloud build trigger timeout"
  type        = string
  default     = "1800s"
}


variable "notification_channel" {
  description = "List of notification channels for alerts"
  type        = string
  default     = ""
}


variable "create_registry" {
  description = "Whether artifact registry repos should be created"
  type        = bool
  default     = true
}


variable "separate_ci" {
  description = "Whether cloudbuild triggers should build each container separately, or together and use Helm for CD"
  type        = bool
  default     = false
}


variable "monitoring_suite" {
  description = "Whether monitoring resources should be created"
  type        = bool
  default     = true
}


variable "uptime_trigger_count" {
  description = "Integer representing the number of failed checks before triggering an alert"
  type        = number
  default     = 1
}


variable "uptime_trigger_duration" {
  description = "Amount of time that a time series must fail to report new data to be considered failing"
  type        = string
  default     = "300s"
}


variable "selected_regions" {
  description = "List of regions to use in uptime checks"
  type        = list(string)
  default = [
    "USA",
  ]
}


variable "create_trigger" {
  description = "Whether Cloudbuild trigger should get created"
  type        = bool
  default     = true
}


variable "create_buckets" {
  description = "Whether Cloud Storage Buckets should get created"
  type        = bool
  default     = true
}


variable "create_k8s_secrets" {
  description = "Whether secrets should get created using the K8s TF provider"
  type        = bool
  default     = true
}


variable "secrets_list" {
  description = "List of GSM secret names"
  type        = list(string)
  default     = []
}


variable "use_django" {
  description = "Whether Django key should be added k8s secret"
  type        = string
  default     = true
}


variable "django_secret_name" {
  description = "GSM secret name with Django Key in it"
  type        = string
  default     = "django-key"
}


variable "use_rapid_api" {
  description = "Whether RapidAPI key should be pulled from GSM"
  type        = bool
  default     = false
}


variable "rapid_api_secret_name" {
  description = "GSM secret name with RapidAPI key in it"
  type        = string
  default     = "rapid-api-key"
}


variable "use_groupme" {
  description = "Whether groupme access token should be pulled from GSM"
  type        = bool
  default     = false
}


variable "groupme_secret_name" {
  description = "GSM secret name with groupme access token in it"
  type        = string
  default     = "groupme-access-token"
}


variable "use_gmaps" {
  description = "Whether Google Maps key should be added k8s secret"
  type        = string
  default     = false
}


variable "gmaps_secret_name" {
  description = "GSM secret name with Google Maps Key in it"
  type        = string
  default     = "maps-key"
}


variable "use_google_oauth" {
  description = "Whether Google Oauth credentials should be created as k8s secrets"
  type        = string
  default     = true
}


variable "oauth_secret_names" {
  description = "List of GSM secret names with Google Oauth credentials"
  type        = list(string)
  default = [
    "google-oauth-id",
    "google-oauth-secret"
  ]
}


variable "use_crm" {
  description = "Whether CRM service should be deployed"
  type        = string
  default     = false
}


variable "use_attom" {
  description = "Whether ATTOM Data API key should be used"
  type        = string
  default     = false
}


variable "attom_secret_name" {
  description = "Name of ATTOM Data api key secret in GSM"
  type        = string
  default     = "attom-data-api-key"
}


variable "use_jwt" {
  description = "Whether JWT auth is used and a secret key should be pulled"
  type        = string
  default     = false
}


variable "jwt_secret_name" {
  description = "Name of secret key in GSM"
  type        = string
  default     = "secret-key"
}


variable "use_sendgrid" {
  description = "Whether app should use sendgrid"
  type        = string
  default     = false
}


variable "sendgrid_secret_name" {
  description = "GSM secret name with Sendgrid API key"
  type        = string
  default     = "sendgrid-key"
}


variable "use_deepai" {
  description = "Whether app should use DeepAI"
  type        = string
  default     = false
}


variable "deepai_secret_name" {
  description = "GSM secret name with DeepAI API key"
  type        = string
  default     = "deepai-key"
}


variable "use_openai" {
  description = "Whether app should use OpenAI"
  type        = string
  default     = false
}


variable "openai_secret_name" {
  description = "GSM secret name with OpenAI API key"
  type        = string
  default     = "openai-key"
}


variable "use_twilio" {
  description = "Whether app should use twilio"
  type        = string
  default     = false
}


variable "twilio_secret_names" {
  description = "List of GSM secret names with Twilio credentials"
  type        = list(string)
  default = [
    "twilio-account-sid",
    "twilio-auth-token",
  ]
}


variable "use_wiseagent" {
  description = "Whether app should use Wise Agent"
  type        = string
  default     = false
}


variable "wiseagent_secret_names" {
  description = "List of GSM secret names with WiseAgent credentials"
  type        = list(string)
  default = [
    "wise-agent-auth-token",
    "wise-agent-key",
  ]
}


variable "use_twilio_flex" {
  description = "Whether app should use twilio flex"
  type        = string
  default     = false
}


variable "twilio_flex_secret_names" {
  description = "List of GSM secret names with Twilio flex credentials"
  type        = list(string)
  default = [
    "twilio-flex-workflow-sid",
    "twilio-flex-workspace-id",
  ]
}


variable "use_airtable" {
  description = "Whether Airtable API key should be used"
  type        = string
  default     = false
}


variable "airtable_secret_names" {
  description = "List of GSM secret names with Airtable credentials"
  type        = list(string)
  default = [
    "base-id",
    "api-key",
  ]
}


variable "app_chart_repo" {
  description = "Application helm chart repo url"
  type        = string
  default     = "theboarderline.github.io/helm-charts"
}


variable "chart_name" {
  description = "Name of application helm chart"
  type        = string
  default     = "web-app"
}


variable "chart_values_path" {
  description = "Path to application helm chart values files (one per lifecycle)"
  type        = string
  default     = "./helm/values"
}


variable "chart_version" {
  description = "Application helm chart version"
  type        = string
  default     = "0.4.19"
}


variable "cicd_cache_enabled" {
  description = "Whether cicd triggers should cache layers"
  type        = bool
  default     = true
}


variable "use_kaniko" {
  description = "Whether or not kaniko should be used for cicd triggers"
  type        = bool
  default     = false
}


variable "basic_cicd_extra_args" {
  description = "Args used to specify extra CI build details when not using kaniko"
  type        = list(string)
  default     = []
}


variable "kaniko_version" {
  description = "Kaniko version tag used in CI"
  type        = string
  default     = "v1.23.2"
}


variable "kaniko_extra_args" {
  description = "Kaniko args used to specify extra CI build details"
  type        = list(string)
  default = [
    "--snapshot-mode=redo",
  ]
}



