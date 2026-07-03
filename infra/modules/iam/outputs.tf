output "runtime_service_account" {
  value       = var.runtime_service_account
  description = "Runtime service account"
}

output "runtime_member" {
  value       = "serviceAccount:${var.runtime_service_account}"
  description = "IAM member string for runtime service account"
}
