locals {
  dbt_airflow_test = {
    job_name                     = "dbt-test-job-c-run"
    container_image              = "us-central1-docker.pkg.dev/new-map-project-1538399427267/dbt-images/dbt_test:latest"
    workflow_name                = "dbt_test_workflow_new"
    runtime_service_account      = "github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"
    log_bucket_name              = "dbt_logs_test_2026"
    workflow_schedule_cron       = "0 6 * * *"
    workflow_schedule_time_zone  = "Asia/Kolkata"
    workflow_schedule_paused     = false
    snowflake_password_secret_id = "SNOWFLAKE_PASSWORD"
    slack_webhook_secret_id      = "SLACK_WEBHOOK"
  }
}

module "dbt_airflow_test_cloud_run_job" {
  source = "./modules/cloud_run_job"

  project_id                   = var.project_id
  region                       = var.region
  job_name                     = local.dbt_airflow_test.job_name
  container_image              = local.dbt_airflow_test.container_image
  runtime_service_account      = local.dbt_airflow_test.runtime_service_account
  log_bucket_name              = local.dbt_airflow_test.log_bucket_name
  snowflake_password_secret_id = local.dbt_airflow_test.snowflake_password_secret_id

  depends_on = [module.project_services]
}

module "dbt_airflow_test_workflows" {
  source = "./modules/workflows"

  project_id              = var.project_id
  project_number          = var.project_number
  region                  = var.region
  job_name                = local.dbt_airflow_test.job_name
  workflow_name           = local.dbt_airflow_test.workflow_name
  runtime_service_account = local.dbt_airflow_test.runtime_service_account
  workflow_source_path    = var.workflow_source_path
  slack_webhook_secret_id = local.dbt_airflow_test.slack_webhook_secret_id
  schedule_cron           = local.dbt_airflow_test.workflow_schedule_cron
  schedule_time_zone      = local.dbt_airflow_test.workflow_schedule_time_zone
  schedule_paused         = local.dbt_airflow_test.workflow_schedule_paused

  depends_on = [module.project_services]
}

module "dbt_airflow_test_iam" {
  count  = var.manage_iam_bindings ? 1 : 0
  source = "./modules/iam"

  project_id                   = var.project_id
  region                       = var.region
  runtime_service_account      = local.dbt_airflow_test.runtime_service_account
  log_bucket_name              = local.dbt_airflow_test.log_bucket_name
  snowflake_password_secret_id = local.dbt_airflow_test.snowflake_password_secret_id
  slack_webhook_secret_id      = local.dbt_airflow_test.slack_webhook_secret_id

  depends_on = [module.project_services]
}

module "dbt_airflow_test_secret_manager_refs" {
  source = "./modules/secret_manager_refs"

  project_id                   = var.project_id
  snowflake_password_secret_id = local.dbt_airflow_test.snowflake_password_secret_id
  slack_webhook_secret_id      = local.dbt_airflow_test.slack_webhook_secret_id

  depends_on = [module.project_services]
}