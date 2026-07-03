data "google_secret_manager_secret" "snowflake_password" {
	project   = var.project_id
	secret_id = var.snowflake_password_secret_id
}

data "google_secret_manager_secret" "slack_webhook" {
	project   = var.project_id
	secret_id = var.slack_webhook_secret_id
}
