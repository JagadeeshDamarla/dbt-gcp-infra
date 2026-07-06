# Infrastructure README

This folder owns the GCP infrastructure for the dbt runtime. It should describe and manage the things that exist around the dbt image, not the dbt SQL itself.

## What This Repo Owns

The infra repo is responsible for:

- Cloud Run Job definition
- GCP Workflow definition
- Cloud Scheduler trigger
- IAM bindings required by the runtime identity
- Secret Manager references and access grants
- API enablement required for the platform
- Terraform state, imports, plan, and apply

The integration repo is responsible for:

- dbt project code
- image build and push
- deploy-time dbt syntax validation
- runtime dbt execution inside Cloud Run

## Current Operating Model

The current platform is runtime-driven:

1. GitHub Actions in the integration repo validates the project mapping, runs `dbt deps` and `dbt parse`, then builds and pushes the image.
2. The infra repo keeps the Cloud Run Job and Workflow definitions in Terraform.
3. The GCP Workflow triggers the Cloud Run Job with runtime parameters.
4. The Cloud Run container runs dbt and uploads logs/artifacts to GCS.

Important rule:

- if a change affects actual GCP resources, it belongs here
- if a change only affects dbt SQL or container runtime behavior, it belongs in the integration repo

## Repository Layout

The current layout follows a rock-style pattern where each pipeline has its own Terraform file.

- `main.tf` keeps shared base resources such as API enablement
- `variables.tf` keeps shared input variables
- `providers.tf` keeps provider and backend configuration
- `constants.tf` keeps shared environment metadata
- `dbt_airflow_test.tf` defines one dbt pipeline end to end
- `config/workflow.yaml` defines the GCP Workflow that runs the job
- `modules/` contains reusable Terraform modules for Cloud Run, Workflows, IAM, and Secret Manager references

## How To Update Infra

### If you change schedule, job name, workflow name, runtime identity, or secrets

Update the matching pipeline file in `infra/`.

For example, in `dbt_airflow_test.tf` you would update:

- `job_name`
- `container_image`
- `workflow_name`
- `runtime_service_account`
- `log_bucket_name`
- `workflow_schedule_cron`
- `workflow_schedule_time_zone`
- `snowflake_password_secret_id`
- `slack_webhook_secret_id`

### If you add a new dbt pipeline

1. create a new `*.tf` file in `infra/`
2. copy the local pipeline config pattern from `dbt_airflow_test.tf`
3. wire Cloud Run, Workflow, Scheduler, IAM, and secret refs
4. add any required secret access or API enablement changes

### If you change runtime payload shape

Update `config/workflow.yaml` when you change:

- `dbt_select`
- `dbt_vars`
- `dbt_params`
- notification payload fields

## Validation Commands

From the infra root:

```bash
cd infra
terraform fmt -recursive
terraform validate
```

Example plan flow:

```bash
cp prod.tfvars.example prod.tfvars
terraform init -backend-config="bucket=<terraform-state-bucket>" -backend-config="prefix=dbt-airflow-test/prod"
terraform plan -var-file=prod.tfvars
```

Apply only after the plan matches the expected state.

## Current Import / Drift Expectations

If the resources already exist in GCP:

1. import them before apply
2. confirm the Terraform names match the live names
3. keep the plan clean before enabling auto-apply

If CI cannot manage IAM policy updates:

- keep `manage_iam_bindings = false`
- manage IAM separately or through a higher-privileged path

## Default API Set

Terraform enables the core APIs before provisioning the pipeline resources.

The common set includes:

- `artifactregistry.googleapis.com`
- `iam.googleapis.com`
- `logging.googleapis.com`
- `run.googleapis.com`
- `secretmanager.googleapis.com`
- `serviceusage.googleapis.com`
- `storage.googleapis.com`
- `workflows.googleapis.com`

You can override the list through the `required_apis` variable.

## Scheduling

The default schedule for the current pipeline is:

- cron: `0 6 * * *`
- timezone: `Asia/Kolkata`

The Workflow remains manually runnable from GCP even when the schedule is enabled.

## IAM Toggle

Use `manage_iam_bindings` to control whether Terraform creates IAM bindings:

- `false`: skip IAM binding resources, useful when the CI identity cannot edit project IAM
- `true`: let Terraform own the IAM bindings, useful when the pipeline has elevated permissions

## Environment Expectation

This repo assumes the environment has already been bootstrapped with:

- a GCS backend bucket for Terraform state
- the target GCP project and region
- any prerequisite secrets in Secret Manager
- enough permissions for the workflow runtime service account

Do not treat this repo as a place to define dbt models or SQL logic. It should only describe and manage the supporting GCP infrastructure.
