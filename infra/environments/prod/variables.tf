variable "job_name" {
  type        = string
  description = "Cloud Run Job name"
}

variable "container_image" {
  type        = string
  description = "Container image URI for Cloud Run Job"
}

variable "workflow_name" {
  type        = string
  description = "Cloud Workflow name"
}

variable "project_number" {
  type        = string
  description = "GCP project number"
}

variable "runtime_service_account" {
  type        = string
  description = "Service account used by the Cloud Run Job and/or workflow runtime"
}

variable "log_bucket_name" {
  type        = string
  description = "Bucket name for dbt artifact logs"
}

variable "snowflake_account" {
  type        = string
  description = "Snowflake account identifier"
}

variable "snowflake_user" {
  type        = string
  description = "Snowflake user name"
}

variable "snowflake_role" {
  type        = string
  description = "Snowflake role"
}

variable "snowflake_database" {
  type        = string
  description = "Snowflake database"
}

variable "snowflake_warehouse" {
  type        = string
  description = "Snowflake warehouse"
}

variable "snowflake_schema" {
  type        = string
  description = "Snowflake schema"
}

variable "workflow_source_path" {
  type        = string
  description = "Filesystem path to workflow YAML source"
  default     = "../../config/workflow.yaml"
}

variable "snowflake_password_secret_id" {
  type        = string
  description = "Secret id for Snowflake password"
  default     = "SNOWFLAKE_PASSWORD"
}

variable "slack_webhook_secret_id" {
  type        = string
  description = "Secret id for Slack webhook"
  default     = "SLACK_WEBHOOK"
}

variable "workflow_schedule_cron" {
  type        = string
  description = "Cron schedule for workflow execution"
  default     = "0 6 * * *"
}

variable "workflow_schedule_time_zone" {
  type        = string
  description = "Timezone for workflow scheduler"
  default     = "Asia/Kolkata"
}

variable "workflow_schedule_paused" {
  type        = bool
  description = "Whether workflow scheduler is paused"
  default     = false
}

variable "required_apis" {
  type        = list(string)
  description = "Project APIs required by the dbt Cloud Run + Workflows stack"
  default = [
    "artifactregistry.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "workflows.googleapis.com"
  ]
}

variable "manage_iam_bindings" {
  type        = bool
  description = "Whether Terraform should manage project/bucket/secret IAM bindings for runtime service account"
  default     = false
}
