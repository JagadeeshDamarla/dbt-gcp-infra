variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "workflow_name" {
  type        = string
  description = "Workflow name"
}

variable "runtime_service_account" {
  type        = string
  description = "Workflow runtime service account"
}

variable "workflow_source_path" {
  type        = string
  description = "Filesystem path to workflow YAML source"
}

variable "job_name" {
  type        = string
  description = "Cloud Run Job name invoked by Workflow"
}

variable "project_number" {
  type        = string
  description = "GCP project number used to build secret resource paths"
}

variable "slack_webhook_secret_id" {
  type        = string
  description = "Secret id for Slack webhook"
}

variable "schedule_cron" {
  type        = string
  description = "Cron schedule for Workflow execution"
}

variable "schedule_time_zone" {
  type        = string
  description = "Timezone for scheduler cron"
}

variable "schedule_paused" {
  type        = bool
  description = "Whether scheduler should be paused"
}
