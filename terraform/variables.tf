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

# Availability Zone used for the public subnet.
variable "availability_zone" {
  description = "Availability Zone for subnet creation."
  type        = string
  default     = "ap-south-1a"
}

# EC2 instance size for the application host.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# Base AMI ID for EC2 instance creation.
variable "ami_id" {
  description = "AMI ID for the EC2 instance. Replace with a valid AMI for your region."
  type        = string
  default     = "ami-xxxxxxxxxxxxxxxxx"
}

# Optional SSH key pair for secure instance access.
variable "key_pair_name" {
  description = "Existing EC2 key pair name for SSH access (optional)."
  type        = string
  default     = ""
}

# Docker image reference used by EC2 user data during deployment.
variable "docker_image" {
  description = "Docker image URL (for example, username/mini-idp:tag)."
  type        = string
  default     = "your-dockerhub-username/mini-idp:latest"
}

# Restrict SSH access to a trusted CIDR range when possible.
variable "ssh_allowed_cidr" {
  description = "CIDR block allowed for SSH access."
  type        = string
  default     = "0.0.0.0/0"
}
