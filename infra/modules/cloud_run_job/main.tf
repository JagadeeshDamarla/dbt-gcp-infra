resource "google_cloud_run_v2_job" "this" {
	project  = var.project_id
	name     = var.job_name
	location = var.region

	template {
		template {
			service_account = var.runtime_service_account
			max_retries     = 0

			containers {
				image = var.container_image

				env {
					name  = "DBT_LOG_BUCKET"
					value = var.log_bucket_name
				}

				env {
					name = "SNOWFLAKE_PASSWORD"
					value_source {
						secret_key_ref {
							secret  = var.snowflake_password_secret_id
							version = "latest"
						}
					}
				}
			}
		}
	}

	lifecycle {
		# GitHub Actions updates the job image per commit.
		ignore_changes = [template[0].template[0].containers[0].image]
	}
}
