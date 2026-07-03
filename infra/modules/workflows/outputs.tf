output "workflow_name" {
  value       = google_workflows_workflow.this.name
  description = "Workflow name"
}

output "workflow_id" {
  value       = google_workflows_workflow.this.id
  description = "Workflow resource id"
}

output "scheduler_name" {
  value       = google_cloud_scheduler_job.workflow_trigger.name
  description = "Cloud Scheduler job name that triggers the workflow"
}
