# Terraform Infra Scaffold

This folder is the Terraform foundation for the GCP infrastructure that supports the dbt Cloud Run + Workflows setup.

## Phase 1 goals
- Pin Terraform and provider versions.
- Configure remote state in GCS.
- Define environment root(s) for import and drift control.
- Add reusable module boundaries for Cloud Run, Workflows, IAM, and Secret Manager references.

## Operating model
- GitHub Actions remains the CI/CD tool for app builds and deploy orchestration.
- Terraform manages infrastructure state and resource definitions.
- Application image deploys can continue through GitHub Actions while infra is codified in Terraform.

## Next steps
1. Create the GCS backend bucket for Terraform state.
2. Fill in the `prod` environment variables.
3. Run plan and import existing Cloud Run Job, Workflow, and IAM bindings.
4. Apply only after plan shows expected drift.

## How to test the scaffold
From the environment root:

```bash
cd infra/environments/prod
terraform init \
	-backend-config="bucket=<terraform-state-bucket>" \
	-backend-config="prefix=dbt-airflow-test/prod"

terraform fmt -recursive
terraform validate
```

To use the example variables file:

```bash
cp prod.tfvars.example prod.tfvars
terraform plan -var-file=prod.tfvars
```

## Current blockers for apply
1. The remote state bucket must exist before `terraform init`.
2. Existing resources should be imported first to avoid accidental recreation.

## API enablement
Terraform now enables required APIs via `module.project_services` before provisioning other resources.
The default managed list includes:
1. `artifactregistry.googleapis.com`
2. `iam.googleapis.com`
3. `logging.googleapis.com`
4. `run.googleapis.com`
5. `secretmanager.googleapis.com`
6. `serviceusage.googleapis.com`
7. `storage.googleapis.com`
8. `workflows.googleapis.com`

You can override this list per environment using the `required_apis` variable.

## Import commands (prod)
Run these from `infra/environments/prod` after `terraform init`:

```bash
terraform import 'module.cloud_run_job.google_cloud_run_v2_job.this' \
	projects/new-map-project-1538399427267/locations/us-central1/jobs/dbt-snowflake-production-job

terraform import 'module.workflows.google_workflows_workflow.this' \
	projects/new-map-project-1538399427267/locations/us-central1/workflows/dbt-orchestrator

terraform import 'module.iam.google_project_iam_member.workflow_run_developer' \
	"new-map-project-1538399427267 roles/run.developer serviceAccount:github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"

terraform import 'module.iam.google_project_iam_member.workflow_logging_writer' \
	"new-map-project-1538399427267 roles/logging.logWriter serviceAccount:github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"

terraform import 'module.iam.google_storage_bucket_iam_member.log_bucket_object_admin' \
	"b/dbt_logs_test_2026 roles/storage.objectAdmin serviceAccount:github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"

terraform import 'module.iam.google_secret_manager_secret_iam_member.snowflake_password_accessor' \
	"projects/new-map-project-1538399427267/secrets/SNOWFLAKE_PASSWORD roles/secretmanager.secretAccessor serviceAccount:github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"

terraform import 'module.iam.google_secret_manager_secret_iam_member.slack_webhook_accessor' \
	"projects/new-map-project-1538399427267/secrets/SLACK_WEBHOOK roles/secretmanager.secretAccessor serviceAccount:github-actions-dbt@new-map-project-1538399427267.iam.gserviceaccount.com"
```

## CI split
1. GitHub Actions remains the CI/CD runner.
2. Terraform workflow manages infra plan/apply.
3. App repo deploy workflow builds/pushes image and updates the existing Cloud Run Job image only.
4. Infra repo owns Cloud Run Job and Workflow definitions via Terraform.
