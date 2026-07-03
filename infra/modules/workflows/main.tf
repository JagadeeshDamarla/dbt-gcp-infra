resource "google_workflows_workflow" "this" {
	project         = var.project_id
	name            = var.workflow_name
	region          = var.region
	service_account = var.runtime_service_account
	source_contents = file(var.workflow_source_path)
}

resource "google_cloud_scheduler_job" "workflow_trigger" {
	project   = var.project_id
	name      = "${var.workflow_name}-scheduler"
	region    = var.region
	schedule  = var.schedule_cron
	time_zone = var.schedule_time_zone
	paused    = var.schedule_paused

	http_target {
		http_method = "POST"
		uri         = "https://workflowexecutions.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.this.name}/executions"

		headers = {
			"Content-Type" = "application/json"
		}

		body = base64encode(jsonencode({
			argument = jsonencode({
				region   = var.region
				job_name = var.job_name
				notification_template = {
					provider = "slack"
					slack_webhook_secret_resource = "projects/${var.project_number}/secrets/${var.slack_webhook_secret_id}"
					attributes = {
						region             = "region"
						operation          = "operation"
						workflow_execution = "workflow_execution"
					}
					status_icons = {
						started = ":information_source:"
						success = ":white_check_mark:"
						failure = ":x:"
					}
				}
			})
		}))

		oauth_token {
			service_account_email = var.runtime_service_account
		}
	}
}
