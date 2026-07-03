locals {
	runtime_member = "serviceAccount:${var.runtime_service_account}"
}

resource "google_project_iam_member" "workflow_run_developer" {
	project = var.project_id
	role    = "roles/run.developer"
	member  = local.runtime_member
}

resource "google_project_iam_member" "workflow_logging_writer" {
	project = var.project_id
	role    = "roles/logging.logWriter"
	member  = local.runtime_member
}

resource "google_storage_bucket_iam_member" "log_bucket_object_admin" {
	bucket = var.log_bucket_name
	role   = "roles/storage.objectAdmin"
	member = local.runtime_member
}

resource "google_secret_manager_secret_iam_member" "snowflake_password_accessor" {
	project   = var.project_id
	secret_id = var.snowflake_password_secret_id
	role      = "roles/secretmanager.secretAccessor"
	member    = local.runtime_member
}

resource "google_secret_manager_secret_iam_member" "slack_webhook_accessor" {
	project   = var.project_id
	secret_id = var.slack_webhook_secret_id
	role      = "roles/secretmanager.secretAccessor"
	member    = local.runtime_member
}
