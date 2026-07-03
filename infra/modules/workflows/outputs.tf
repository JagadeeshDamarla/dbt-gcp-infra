output "workflow_name" {
  value       = google_workflows_workflow.this.name
  description = "Workflow name"
}

output "workflow_id" {
  value       = google_workflows_workflow.this.id
  description = "Workflow resource id"
}
