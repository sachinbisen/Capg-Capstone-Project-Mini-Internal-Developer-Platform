# Mini Internal Developer Platform
This repository contains a beginner-friendly Platform Engineering capstone project that demonstrates how to build a mini Internal Developer Platform (IDP) using GitHub Actions, Terraform, Docker, and AWS.

## Project Objective
The objective of this project is to design a simple but professional end-to-end platform workflow where:
- developers ship application updates quickly,
- infrastructure is provisioned through Infrastructure as Code (IaC),
- deployments are automated through CI/CD,
- and operational visibility is enabled through monitoring.

## Platform Engineering Concept
Platform Engineering focuses on building reusable internal platforms that improve developer experience and delivery speed. In this capstone, the "platform" provides:
- standardized deployment automation,
- self-service style infrastructure provisioning,
- consistent containerized packaging,
- and observability hooks for runtime monitoring.

## Project Architecture
The mini IDP combines source control, CI/CD, infrastructure provisioning, containerization, and cloud monitoring into one workflow.

### End-to-End Architecture Flow
Developer Push  
→ GitHub Actions  
→ Terraform Provisioning  
→ Docker Build  
→ Docker Hub Push  
→ EC2 Auto Deployment  
→ CloudWatch Monitoring

### Architecture Components
- **Developer Push**: Code updates are pushed to the main branch.
- **GitHub Actions**: Executes CI/CD automation for build and deployment.
- **Terraform Provisioning**: Creates/updates AWS networking, EC2, and monitoring  resources.
- **Docker Build**: Packages the Node.js app into a portable container image.
- **Docker Hub Push**: Stores versioned container images in a registry.
- **EC2 Auto Deployment**: Pulls and runs the latest image on an EC2 host.
- **CloudWatch Monitoring**: Tracks infrastructure and host-level health metrics.

## Deployment Workflow
1. Developer pushes code to `main`.
2. GitHub Actions pipeline starts automatically.
3. Docker image is built from `app/Dockerfile`.
4. Image is pushed to Docker Hub.
5. Terraform provisions or updates AWS infrastructure.
6. EC2 user data pulls the latest image and starts the container.
7. CloudWatch alarms monitor system behavior (for example, CPU thresholds).

## CI/CD Workflow
The workflow file `.github/workflows/deploy.yml` is structured to:
1. check out source code,
2. install application dependencies,
3. build and push Docker image,
4. initialize and validate Terraform,
5. apply Terraform to deploy infrastructure and release the app.

## Technologies Used
- **Node.js + Express** for the sample application
- **Docker** for containerization
- **Terraform** for Infrastructure as Code
- **AWS (VPC, EC2, Security Groups, CloudWatch)** for runtime environment
- **GitHub Actions** for CI/CD automation
- **Docker Hub** for image registry

## Folder Structure
```text
Capg-Capstone-Project-Mini-Internal-Developer-Platform/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── app/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── docs/
│   └── README.md
├── governance/
│   └── README.md
├── monitoring/
│   └── README.md
├── terraform/
│   ├── ec2.tf
│   ├── main.tf
│   ├── monitoring.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── .gitignore
└── README.md
```

## Getting Started
1. Add required GitHub repository secrets:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
   - `AMI_ID`
2. Update Terraform variable defaults in `terraform/variables.tf` as needed.
3. Push code to `main` to trigger the deployment pipeline.

## Notes for Beginners
- This project intentionally keeps modules simple and readable.
- The structure can be extended later with environments (`dev/stage/prod`) and reusable Terraform modules.
- Start with one reliable flow first, then scale complexity gradually.
