# Define Terraform and AWS provider version requirements.
# Keeping versions explicit makes project behavior more predictable for beginners.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS provider using a variable-driven region.
provider "aws" {
  region = var.aws_region
}
