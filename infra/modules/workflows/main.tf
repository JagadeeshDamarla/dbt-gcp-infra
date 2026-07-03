resource "google_workflows_workflow" "this" {
	project         = var.project_id
	name            = var.workflow_name
	region          = var.region
	service_account = var.runtime_service_account
	source_contents = file(var.workflow_source_path)
}
