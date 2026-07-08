module "project_services" {
  source = "./modules/project_services"

  project_id    = var.project_id
  required_apis = var.required_apis
}

resource "google_artifact_registry_repository" "dbt_images" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
  description   = "Docker images for dbt Cloud Run jobs"

  depends_on = [module.project_services]
}