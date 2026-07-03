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

variable "runtime_service_account" {
  type        = string
  description = "Service account used by the Cloud Run Job and/or workflow runtime"
}

variable "log_bucket_name" {
  type        = string
  description = "Bucket name for dbt artifact logs"
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

variable "required_apis" {
  type        = list(string)
  description = "Project APIs required by the dbt Cloud Run + Workflows stack"
  default = [
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "workflows.googleapis.com"
  ]
}
