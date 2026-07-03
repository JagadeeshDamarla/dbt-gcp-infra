output "cloud_run_job_name" {
  value       = module.cloud_run_job.job_name
  description = "Cloud Run Job name"
}

output "workflow_name" {
  value       = module.workflows.workflow_name
  description = "Cloud Workflow name"
}

output "runtime_service_account" {
  value       = var.runtime_service_account
  description = "Runtime service account used by the deployed resources"
}

output "project_id" {
  value       = var.project_id
  description = "GCP project id for app deployment repo"
}

output "region" {
  value       = var.region
  description = "Primary region for Cloud Run and Workflows"
}

output "log_bucket_name" {
  value       = var.log_bucket_name
  description = "GCS bucket used by dbt job to upload artifacts"
}

output "slack_webhook_secret_name" {
  value       = module.secret_manager_refs.slack_webhook_secret_name
  description = "Full resource name of Slack webhook secret"
}
