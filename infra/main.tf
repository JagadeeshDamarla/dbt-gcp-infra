module "project_services" {
  source = "./modules/project_services"

  project_id    = var.project_id
  required_apis = var.required_apis
}