module "project_services" {
  source = "../../modules/project_services"

  project_id    = var.project_id
  required_apis = var.required_apis
}

module "cloud_run_job" {
  source = "../../modules/cloud_run_job"

  project_id              = var.project_id
  region                  = var.region
  job_name                = var.job_name
  container_image         = var.container_image
  runtime_service_account = var.runtime_service_account
  log_bucket_name         = var.log_bucket_name
  snowflake_password_secret_id = var.snowflake_password_secret_id

  depends_on = [module.project_services]
}

module "workflows" {
  source = "../../modules/workflows"

  project_id               = var.project_id
  region                   = var.region
  workflow_name            = var.workflow_name
  runtime_service_account  = var.runtime_service_account
  workflow_source_path     = var.workflow_source_path

  depends_on = [module.project_services]
}

module "iam" {
  count  = var.manage_iam_bindings ? 1 : 0
  source = "../../modules/iam"

  project_id                   = var.project_id
  region                       = var.region
  runtime_service_account      = var.runtime_service_account
  log_bucket_name              = var.log_bucket_name
  snowflake_password_secret_id = var.snowflake_password_secret_id
  slack_webhook_secret_id      = var.slack_webhook_secret_id

  depends_on = [module.project_services]
}

module "secret_manager_refs" {
  source = "../../modules/secret_manager_refs"

  project_id                   = var.project_id
  snowflake_password_secret_id = var.snowflake_password_secret_id
  slack_webhook_secret_id      = var.slack_webhook_secret_id

  depends_on = [module.project_services]
}
