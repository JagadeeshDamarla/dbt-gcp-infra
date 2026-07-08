output "cloud_run_job_names" {
  value = {
    dbt_airflow_test = module.dbt_airflow_test_cloud_run_job.job_name
  }
  description = "Cloud Run Job names by pipeline"
}

output "workflow_names" {
  value = {
    dbt_airflow_test = module.dbt_airflow_test_workflows.workflow_name
  }
  description = "Workflow names by pipeline"
}

output "workflow_scheduler_names" {
  value = {
    dbt_airflow_test = module.dbt_airflow_test_workflows.scheduler_name
  }
  description = "Cloud Scheduler job names by pipeline"
}

output "runtime_service_accounts" {
  value = {
    dbt_airflow_test = local.dbt_airflow_test.runtime_service_account
  }
  description = "Runtime service accounts by pipeline"
}

output "project_id" {
  value       = var.project_id
  description = "GCP project id for app deployment repo"
}

output "region" {
  value       = var.region
  description = "Primary region for Cloud Run and Workflows"
}

output "log_bucket_names" {
  value = {
    dbt_airflow_test = local.dbt_airflow_test.log_bucket_name
  }
  description = "GCS buckets used by dbt pipelines to upload artifacts"
}

output "artifact_registry_repository" {
  value = {
    name          = google_artifact_registry_repository.dbt_images.name
    repository_id = google_artifact_registry_repository.dbt_images.repository_id
    location      = google_artifact_registry_repository.dbt_images.location
  }
  description = "Artifact Registry Docker repository managed by Terraform"
}

output "slack_webhook_secret_names" {
  value = {
    dbt_airflow_test = module.dbt_airflow_test_secret_manager_refs.slack_webhook_secret_name
  }
  description = "Full Slack webhook secret resource names by pipeline"
}