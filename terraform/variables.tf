# AWS region where infrastructure resources will be created.
variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "ap-south-1"
}

# Logical project name used for consistent tagging and naming.
variable "project_name" {
  description = "Project name used as a prefix in resource names."
  type        = string
  default     = "mini-idp"
}

# Environment name used in tags for easier filtering in AWS console.
variable "environment" {
  description = "Environment tag (for example: dev, stage, prod)."
  type        = string
  default     = "dev"
}

# CIDR block for the primary VPC.
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# CIDR block for the public subnet hosting the EC2 instance.
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}


# EC2 instance size for the application host.
variable "instance_type" {
  description = "EC2 instance type (Free Tier-friendly default is t2.micro)."
  type        = string
  default     = "t3.micro"
}

# Optional SSH key pair for secure instance access.
variable "key_pair_name" {
  description = "Existing EC2 key pair name for SSH access (optional)."
  type        = string
  default     = ""
}

# Docker image reference used by EC2 user data during deployment.
variable "docker_image" {
  description = "Docker image URL used by EC2 bootstrap (Docker Hub image)."
  type        = string
  default     = "260104/mini-idp-app:latest"
}

# Restrict SSH access to a trusted CIDR range when possible.
variable "ssh_allowed_cidr" {
  description = "CIDR block allowed for SSH access."
  type        = string
  default     = "0.0.0.0/0"
}
