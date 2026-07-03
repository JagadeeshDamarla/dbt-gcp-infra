output "enabled_apis" {
  value       = sort(keys(google_project_service.required))
  description = "APIs managed by Terraform for this project"
}
