variable "project_number" {
  type        = string
  description = "GCP project number"
}

variable "workflow_source_path" {
  type        = string
  description = "Filesystem path to workflow YAML source"
  default     = "./config/workflow.yaml"
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