output "project_id" {
  value       = var.project_id
  description = "GCP project id"
}

output "snowflake_password_secret_name" {
  value       = data.google_secret_manager_secret.snowflake_password.name
  description = "Full resource name of Snowflake password secret"
}

output "slack_webhook_secret_name" {
  value       = data.google_secret_manager_secret.slack_webhook.name
  description = "Full resource name of Slack webhook secret"
}
