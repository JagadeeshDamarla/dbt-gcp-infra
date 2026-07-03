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
