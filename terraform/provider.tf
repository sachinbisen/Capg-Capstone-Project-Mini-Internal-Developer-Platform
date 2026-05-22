# Define Terraform and provider version requirements.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider region for all infrastructure resources.
provider "aws" {
  region = var.aws_region
}
