variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "job_name" {
  type        = string
  description = "Cloud Run Job name"
}

variable "runtime_service_account" {
  type        = string
  description = "Cloud Run Job runtime service account"
}

variable "log_bucket_name" {
  type        = string
  description = "Bucket for dbt log artifacts"
}

variable "container_image" {
  type        = string
  description = "Container image URI used by the Cloud Run Job"
}

variable "snowflake_password_secret_id" {
  type        = string
  description = "Secret Manager secret id for SNOWFLAKE_PASSWORD"
  default     = "SNOWFLAKE_PASSWORD"
}
