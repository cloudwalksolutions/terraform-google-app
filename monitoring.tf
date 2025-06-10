
resource "google_monitoring_notification_channel" "email" {
  count = !var.disabled && var.monitoring_suite ? 1 : 0

  project      = var.gke_project_id
  display_name = "${local.lifecycle_name} ${var.app_code} Notification Channel"
  type         = "email"
  labels = {
    email_address = var.admin_email
  }
  force_delete = false
}



resource "google_monitoring_uptime_check_config" "https_uptime" {
  count = !var.disabled && var.monitoring_suite ? 1 : 0

  project = var.gke_project_id

  display_name = title("${local.lifecycle_name} ${var.app_code}")
  timeout      = "60s"

  selected_regions = var.selected_regions

  http_check {
    path         = "/health/"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = local.final_domain
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_monitoring_alert_policy" "alert_policy" {
  count = !var.disabled && var.monitoring_suite ? 1 : 0

  project = var.gke_project_id

  display_name          = title("${local.lifecycle_name} ${var.app_code} Alerts")
  notification_channels = [google_monitoring_notification_channel.email[0].name]
  combiner              = "OR"

  conditions {
    display_name = title("${local.lifecycle_name} ${var.app_code} Uptime Alert")

    # condition_absent {
    #   duration = var.uptime_trigger_duration
    #   trigger {
    #     count = var.uptime_trigger_count
    #   }
    # }

    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.https_uptime[0].uptime_check_id}\" AND resource.type=\"uptime_url\""
      threshold_value = var.uptime_trigger_count
      duration        = var.uptime_trigger_duration
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = "1200s"
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }
    }

  }

  user_labels = {
    app       = var.app_code
    lifecycle = local.lifecycle_name
  }

  depends_on = [
    google_monitoring_notification_channel.email,
    google_monitoring_uptime_check_config.https_uptime,
  ]
}



resource "google_monitoring_dashboard" "dashboard" {
  count = !var.disabled && var.monitoring_suite ? 1 : 0

  project = var.gke_project_id

  dashboard_json = <<EOF
{
  "category": "CUSTOM",
  "displayName": "${local.namespace}",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "Memory Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"kubernetes.io/container/memory/used_bytes\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"${local.namespace}\""
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 0
      },
      {
        "height": 4,
        "widget": {
          "title": "Persistent Disk Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"kubernetes.io/pod/volume/used_bytes\" resource.type=\"k8s_pod\" resource.label.\"namespace_name\"=\"${local.namespace}\" metric.label.\"volume_name\"=\"db-volume\""
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 4,
        "widget": {
          "title": "CPU Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"kubernetes.io/container/cpu/core_usage_time\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"${local.namespace}\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 0,
        "yPos": 4
      },
      {
        "height": 4,
        "widget": {
          "alertChart": {
            "name": "projects/${var.gke_project_id}/alertPolicies/7453247611856152035"
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 4
      }
    ]
  }
}
EOF
}



