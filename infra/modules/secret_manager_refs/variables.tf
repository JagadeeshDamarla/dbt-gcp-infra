variable "project_id" {
  type        = string
  description = "GCP project id"
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
