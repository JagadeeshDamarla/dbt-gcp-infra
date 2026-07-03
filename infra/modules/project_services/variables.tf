variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "required_apis" {
  type        = list(string)
  description = "List of GCP service APIs to enable"
}
