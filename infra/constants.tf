locals {
  repository      = "dbt-gcp-infra"
  github_workflow = "tf-pipeline"
  deployment      = "dbt-cloud-run-workflows"
}

/*
add project, artifact_registry_name, storage bucket
and cloud run project roles and see how these are related
*/