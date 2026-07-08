# dbt-gcp-infra Requirements

## 1. Problem Statement
The repository must provision and manage stable, repeatable GCP infrastructure for dbt execution while allowing the application repository to deploy code independently.

Primary goals:
- Define Cloud Run Job, GCP Workflow, and Scheduler as code.
- Preserve deterministic runtime contracts across environments.
- Control IAM, APIs, and secret access through infrastructure workflows.

## 2. Scope and Ownership
This repository owns:
- Terraform state and infrastructure modules
- Cloud Run Job resource lifecycle
- GCP Workflows resource lifecycle
- Cloud Scheduler lifecycle for automated Workflow execution
- Optional IAM bindings and API enablement

This repository does not own:
- dbt SQL/model code changes
- container image build logic
- app-level deployment decisions

Those are owned by dbt-gcp-integration.

## 3. Architecture Followed
Current architecture:
- Terraform root: infra
- Reusable modules for cloud_run_job, workflows, project_services, iam, secret_manager_refs
- CI pipeline executes Terraform from prod environment root
- Workflows module deploys Workflow source and Scheduler trigger
- Scheduler invokes Workflow daily at 6:00 AM IST by default

Key design choice:
- Scheduler triggers Workflow, and Workflow triggers Cloud Run Job execution.
- App repository deploy updates image only; infra repository controls resource lifecycle.

## 4. Solution Approach Followed
### 4.1 Terraform Pipeline
Workflow file:
- .github/workflows/tf-pipeline.yml

Behavior:
1. Manual trigger only.
2. Auth via WIF + service account.
3. Backend validation for TF state bucket/prefix.
4. Terraform init with explicit backend config.
5. Apply using available tfvars file.

### 4.2 Workflow + Scheduler
Module files:
- infra/modules/workflows/main.tf
- infra/config/workflow.yaml

Behavior:
1. Deploys GCP Workflow definition from file.
2. Creates Cloud Scheduler job to call Workflow execution API.
3. Scheduler sends payload including region, job_name, and notification_template.

### 4.3 Cloud Run Job Runtime Contract
Module file:
- infra/modules/cloud_run_job/main.tf

Current runtime env responsibilities:
- DBT_LOG_BUCKET
- SNOWFLAKE_PASSWORD from Secret Manager

Date vars are passed dynamically by Workflow when starting job execution.

## 5. Functional Requirements
- FR-1: Terraform must create/update Cloud Run Job, Workflow, Scheduler resources.
- FR-2: Workflow must orchestrate Cloud Run execution and terminal status handling.
- FR-3: Scheduler must trigger Workflow at configured cron/timezone.
- FR-4: Infrastructure apply must be non-interactive in CI.
- FR-5: Infra must expose outputs needed by operations and app integration.

## 6. Non-Functional Requirements
- NFR-1: State must be remote in GCS backend.
- NFR-2: Authentication must use OIDC/WIF and least privilege.
- NFR-3: Apply flow should fail fast on missing backend variables or API access.
- NFR-4: Scheduling and workflow payload contract must be explicit and versioned.

## 7. Scheduling Requirements
Default schedule values (prod example):
- workflow_schedule_cron: 0 6 * * *
- workflow_schedule_time_zone: Asia/Kolkata
- workflow_schedule_paused: false

Interpretation:
- Workflow runs every day at 6:00 AM IST.

Manual execution remains available:
- Workflow can be executed directly from GCP UI or gcloud regardless of scheduler.

## 8. Ad-hoc Run Requirements
Ad-hoc operational run path:
1. Execute Workflow manually with payload.
2. Workflow triggers Cloud Run job with date overrides.
3. Workflow emits Slack notifications and terminal status.

Example command:
```bash
gcloud workflows executions run dbt_test_workflow_new \
  --project=new-map-project-1538399427267 \
  --location=us-central1 \
  --data='{"region":"us-central1","job_name":"dbttest-job1","dbt_vars":{"from_date":"2026-07-02","to_date":"2026-07-02"},"notification_template":{"provider":"slack","slack_webhook_secret_resource":"projects/995265336172/secrets/SLACK_WEBHOOK","attributes":{"region":"region","operation":"operation","workflow_execution":"workflow_execution"},"status_icons":{"started":":information_source:","success":":white_check_mark:","failure":":x:"}}}'
```

## 9. Cancellation Requirements
### 9.1 Pause/Resume Schedule
Pause:
```bash
gcloud scheduler jobs pause dbt_test_workflow_new-scheduler \
  --project=new-map-project-1538399427267 \
  --location=us-central1
```

Resume:
```bash
gcloud scheduler jobs resume dbt_test_workflow_new-scheduler \
  --project=new-map-project-1538399427267 \
  --location=us-central1
```

### 9.2 Cancel Active Workflow Execution
```bash
gcloud workflows executions cancel EXECUTION_ID \
  --workflow=dbt_test_workflow_new \
  --project=new-map-project-1538399427267 \
  --location=us-central1
```

### 9.3 Cancel Active Cloud Run Job Execution
```bash
gcloud run jobs executions cancel EXECUTION_NAME \
  --project=new-map-project-1538399427267 \
  --region=us-central1
```

## 10. Notifications and Monitoring
Notification path:
- Workflow sends Slack notifications (started/success/failure) via Secret Manager webhook.

Where to inspect:
1. Workflows execution timeline
2. Cloud Run execution logs
3. Scheduler job history
4. GCS dbt artifacts bucket
5. GitHub Actions Terraform apply logs

## 11. IAM and Permissions Requirements
Minimum practical permissions for CI identity:
- Workload Identity auth permissions
- Terraform target resource permissions
- For scheduler creation: cloudscheduler.jobs.create (via roles/cloudscheduler.admin)
- For service management (if enabled): serviceusage permissions
- For IAM resource management (optional): project IAM policy update permissions

Current operational safeguard:
- manage_iam_bindings default is false to avoid apply failures in low-privilege CI.

## 12. Common Failure Modes
- Service Usage API disabled or inaccessible.
- Missing or incorrect Terraform backend bucket/prefix configuration in the workflow or local init command.
- Missing cloudscheduler.jobs.create permission.
- Missing IAM policy update permission when manage_iam_bindings=true.
- Secret accessor permissions missing for runtime service account.

## 13. Acceptance Criteria
- AC-1: Terraform apply can provision/update Workflow and Scheduler resources.
- AC-2: Scheduler triggers Workflow daily at 6 AM IST.
- AC-3: Manual Workflow execution works with documented payload.
- AC-4: Failure in Cloud Run job is surfaced as Workflow failure.
- AC-5: Operations can pause schedule and cancel active executions via documented commands.
