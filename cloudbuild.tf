

resource "google_cloudbuild_trigger" "cloudbuild_triggers" {
  for_each = !var.disabled && var.create_trigger && var.separate_ci ? toset(var.build_locations) : toset([])

  project = var.app_project_id
  name    = "${local.lifecycle_name}-${each.key}-ci"

  # service_account = local.cicd_service_account
  disabled       = false
  included_files = ["src/${each.key}/**"]
  ignored_files  = var.ignored_files

  github {
    owner = var.github_owner
    name  = var.app_code

    push {
      branch = local.lifecycle_name == "prod" ? "^main$" : "^${local.lifecycle_name}$"
    }
  }

  build {
    timeout = var.trigger_timeout

    step {
      id   = "Build-${each.key}"
      name = local.cicd_build_image
      args = var.use_kaniko ? concat([
        "--destination=${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:$COMMIT_SHA",
        "--destination=${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:latest",
        "--context=./src/${each.key}",
        ], local.kaniko_extra_args) : concat(
        ["build"],
        var.cicd_cache_enabled ? concat(var.basic_cicd_extra_args, [
          "--cache-from",
          "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}"
        ]) : var.basic_cicd_extra_args,
        [
          "-t",
          "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:$COMMIT_SHA",
          "-t",
          "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:latest",
          "./src/${each.key}",
      ])
    }

    images = !var.use_kaniko ? [
      "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:$COMMIT_SHA",
      "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${each.key}:latest",
    ] : []

    options {
      machine_type = var.cicd_machine_type
      logging      = var.logging
    }
  }

}


resource "google_cloudbuild_trigger" "mono_trigger" {
  count = !var.disabled && var.create_trigger && !var.separate_ci ? 1 : 0

  project = var.app_project_id
  name    = "${local.lifecycle_name}-cicd"

  # service_account = local.cicd_service_account
  disabled       = false
  included_files = var.included_files
  ignored_files  = var.ignored_files

  github {
    owner = var.github_owner
    name  = var.app_code

    push {
      branch = local.lifecycle_name == "prod" ? "^main$" : "^${local.lifecycle_name}$"
    }
  }

  build {
    timeout = var.trigger_timeout

    dynamic "step" {
      for_each = toset(distinct(var.build_locations))
      content {
        id   = "Build-${step.value}"
        name = local.cicd_build_image
        args = var.use_kaniko ? concat([
          "--destination=${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${step.value}:$COMMIT_SHA",
          "--destination=${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${step.value}:latest",
          "--context=./src/${step.value}",
          ], local.kaniko_extra_args) : concat(
          ["build"],
          var.cicd_cache_enabled ? concat(var.basic_cicd_extra_args, [
            "--cache-from",
            "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${step.value}"
          ]) : var.basic_cicd_extra_args,
          [
            "-t",
            "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${step.value}:$COMMIT_SHA",
            "-t",
            "${local.registry_prefix}/${var.app_project_id}/${local.registry_id}/${step.value}:latest",
            "./src/${step.value}",
        ])
      }
    }

    images = !var.use_kaniko ? local.images_to_push : []

    step {
      id   = "Update-Images"
      name = "gcr.io/walker-cpl/helm-cd:0.0.10"
      args = [
        "${var.cluster_name}",
        "${local.location}",
        "${var.gke_project_id}",
        "${local.namespace}",
        "${var.chart_version}",
        "$COMMIT_SHA",
        "${var.regional}"
      ]
    }


    options {
      machine_type = var.cicd_machine_type
      logging      = var.logging
    }
  }

}


