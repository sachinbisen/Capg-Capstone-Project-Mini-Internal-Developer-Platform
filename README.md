# Mini Internal Developer Platform
[![Mini IDP Deploy Pipeline](https://github.com/sachinbisen/Capg-Capstone-Project-Mini-Internal-Developer-Platform/actions/workflows/deploy.yml/badge.svg)](https://github.com/sachinbisen/Capg-Capstone-Project-Mini-Internal-Developer-Platform/actions/workflows/deploy.yml)
This capstone project demonstrates a beginner-friendly Platform Engineering setup where Terraform provisions AWS infrastructure, EC2 bootstraps Docker automatically, and CloudWatch provides basic runtime monitoring.

## CI/CD Architecture
The automated deployment pipeline follows this flow:

Developer Push  
→ GitHub Actions (`deploy.yml`)  
→ Node.js Dependency Install  
→ Docker Build (`260104/mini-idp-app:latest`)  
→ Docker Hub Push  
→ Terraform Init + Validate  
→ Terraform Taint EC2  
→ Terraform Apply  
→ Old EC2 Replaced + New EC2 Bootstrapped  
→ Latest Docker Image Deployed

## GitHub Actions Workflow Explanation
The `.github/workflows/deploy.yml` pipeline runs in 10 beginner-friendly stages:
1. Checkout repository
2. Setup Node.js and install dependencies
3. Build Docker image `260104/mini-idp-app:latest`
4. Login to Docker Hub using secrets
5. Push image to Docker Hub
6. Setup Terraform
7. Run `terraform init`
8. Run `terraform validate`
9. Run `terraform taint aws_instance.app_server` (when instance exists)
10. Run `terraform apply -auto-approve`

Triggers:
- Automatic on push to `main`
- Manual from GitHub Actions using `workflow_dispatch`

## GitHub Secrets Used
Configure these repository secrets before running the pipeline:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

These are consumed by the workflow so credentials are not hardcoded in code.

## Terraform State Management (Module 6)
Terraform state is a file that records what infrastructure Terraform has already created (for example VPC, subnet, EC2, alarms, and IDs).

Without this state, Terraform cannot reliably compare:
- **Current infrastructure in AWS**
- **Desired infrastructure defined in code**

### Local State vs Remote State
- **Local state**: `terraform.tfstate` is stored only on the machine running Terraform.
- **Remote state**: `terraform.tfstate` is stored in shared remote storage (S3 in this project).

In CI/CD, remote state is safer and more stable because multiple workflow runs use one shared source of truth.

### Why duplicate infrastructure happened earlier
GitHub Actions runners are **ephemeral** (temporary).  
Each run starts in a fresh environment, so local `terraform.tfstate` from old runs is not preserved.

That made Terraform behave like a first-time deployment repeatedly, which can lead to:
- duplicate resource creation attempts,
- unstable apply behavior,
- state drift and deployment confusion.

### S3 backend fix used in this project
Terraform now uses an S3 remote backend:
- bucket: `sachin-mini-idp-terraform-state`
- key: `mini-idp/terraform.tfstate`
- region: `ap-south-1`
- encryption: enabled (`encrypt = true`)

This ensures every pipeline run reads and updates the same state file.

### Why infrastructure tracking matters
Accurate state tracking allows Terraform to:
1. detect existing resources correctly,
2. apply only required changes,
3. avoid accidental duplication,
4. keep CI/CD deployments deterministic.

This is why remote state is an industry-standard Terraform practice for automated pipelines.

## Terraform State Architecture
State-aware deployment flow:

Developer Push  
→ GitHub Actions  
→ Terraform Init  
→ S3 Remote State  
→ Terraform Apply  
→ AWS Infrastructure

## CI/CD State Persistence Explanation
In this project:
1. GitHub Actions starts a fresh runner.
2. `terraform init` connects to S3 backend.
3. Terraform downloads current state snapshot from S3.
4. Terraform plans/applies against real tracked infrastructure.
5. Updated state is saved back to S3 for the next run.

This prevents state loss between runs and stabilizes Infrastructure as Code automation.

## Automated Deployment Explanation
After each push to `main`, the workflow automatically:
1. Builds and pushes the latest Docker image.
2. Validates infrastructure code.
3. Recreates EC2 (immutable style when state has existing instance).
4. Applies Terraform and provisions the updated infrastructure.
5. Lets EC2 user-data pull and run `260104/mini-idp-app:latest`.
6. Persists Terraform state in S3 so the next pipeline run continues from the latest known infrastructure state.

If any stage fails, the workflow stops immediately and logs the failed step clearly.

## Infrastructure Architecture
The infrastructure pipeline follows this flow:

Developer Push  
→ GitHub Actions  
→ Terraform Apply  
→ EC2 Recreation  
→ Docker Auto Deployment  
→ CloudWatch Monitoring

Beginner-friendly meaning:
- **Developer Push**: source code or Terraform changes are pushed to GitHub.
- **GitHub Actions**: CI runs checks and can trigger Terraform workflow.
- **Terraform Apply**: AWS infrastructure is created/updated from code.
- **EC2 Recreation**: instance can be replaced when bootstrap config changes (immutable style).
- **Docker Auto Deployment**: new EC2 bootstraps itself and starts the app container.
- **CloudWatch Monitoring**: CPU metrics and alarms help observe runtime health.

## What Terraform Provisions
Terraform in `terraform/` creates:
- VPC
- public subnet
- internet gateway
- route table and association
- security group
- EC2 instance
- CloudWatch CPU alarm

## AWS Free Tier Design Choices
- **Instance type**: `t2.micro` (default in variables)
- **OS image**: latest Ubuntu 22.04 LTS AMI from Canonical
- **Network**: single public subnet for simple learning and easy access

## Security Group Rules
The EC2 security group allows:
- TCP `22` (SSH)
- TCP `80` (HTTP)
- TCP `3000` (application port)

## EC2 Bootstrapping Explanation
On first boot, EC2 uses `user_data` to:
1. install Docker (`docker.io`)
2. enable and start Docker service
3. pull image `260104/mini-idp-app:latest` from Docker Hub
4. run container on `3000:3000`
5. enable container auto-restart with `--restart unless-stopped`

This gives automatic application deployment immediately after provisioning.

## Immutable Infrastructure Explanation
The EC2 resource is configured with `user_data_replace_on_change = true`.
That means when bootstrap logic changes (for example image/tag updates passed via Terraform), Terraform recreates the EC2 instance instead of manually patching an existing server. This is a core immutable infrastructure pattern.

In CI/CD, immutable behavior is strengthened with `terraform taint aws_instance.app_server` (when an instance already exists in state), which forces replacement so old EC2 is destroyed and a fresh EC2 is created.

## Docker Auto Deployment Workflow
1. Build/push Docker image to Docker Hub.
2. Run `terraform apply` with the target image tag.
3. Terraform creates or recreates EC2.
4. EC2 pulls the configured image and starts container automatically.

In CI/CD mode, these steps are fully automated by GitHub Actions.

## CloudWatch Monitoring Explanation
CloudWatch monitoring support is enabled at EC2 level (`monitoring = true`) and includes:
- CPU utilization alarm (`> 70%` average over evaluation window)

This gives a simple first step toward production-style observability.

## Terraform Workflow Commands
Run from the `terraform` directory:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Terraform Workflow (Local + CI)
1. Update Terraform code in `terraform/`.
2. Run `terraform validate` and `terraform plan` locally.
3. Commit and push changes to GitHub.
4. GitHub Actions executes Terraform workflow.
5. `terraform apply` reconciles infrastructure state in AWS.
6. If EC2 is recreated, `user_data` re-installs Docker and redeploys app automatically.

## Application Access Outputs
After `terraform apply`, Terraform outputs:
- EC2 public IP
- application URL (port 3000)

## Variables You Can Customize
Important defaults:
- `aws_region` (AWS region)
- `instance_type` = `t2.micro`
- `docker_image` = `260104/mini-idp-app:latest`

## Screenshot Placeholders
Add screenshots here after a successful CI/CD run:
### 1) S3 Bucket
Placeholder path: `docs/screenshots/s3-backend-bucket.png`  
What to capture: `sachin-mini-idp-terraform-state` bucket in AWS console.

### 2) Terraform Backend Configuration
Placeholder path: `docs/screenshots/terraform-backend-config.png`  
What to capture: `terraform/backend.tf` showing S3 backend block.

### 3) Successful GitHub Actions Run
Placeholder path: `docs/screenshots/github-actions-success.png`  
What to capture: green run with successful Terraform init/validate/apply stages.

### 4) EC2 Deployment
Placeholder path: `docs/screenshots/ec2-deployment.png`  
What to capture: running EC2 instance and public IP.

### 5) CloudWatch Alarms
Placeholder path: `docs/screenshots/cloudwatch-alarms.png`  
What to capture: high CPU alarm in CloudWatch.

## Folder Structure
```text
Capg-Capstone-Project-Mini-Internal-Developer-Platform/
├── app/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── terraform/
│   ├── backend.tf
│   ├── provider.tf
│   ├── main.tf
│   ├── network.tf
│   ├── ec2.tf
│   ├── monitoring.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md
```
