output "job_name" {
  value       = google_cloud_run_v2_job.this.name
  description = "Cloud Run Job name"
}

output "job_id" {
  value       = google_cloud_run_v2_job.this.id
  description = "Cloud Run Job resource id"
}
