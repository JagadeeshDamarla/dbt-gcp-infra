variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "runtime_service_account" {
  type        = string
  description = "Service account that needs IAM bindings"
}

variable "log_bucket_name" {
  type        = string
  description = "Bucket used for dbt artifacts"
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
