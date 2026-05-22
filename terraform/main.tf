# Central Terraform configuration shared across infrastructure files.
# Locals and data sources are defined here to keep other files focused on resources.

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "Capg-Capstone-Project-Mini-Internal-Developer-Platform"
  }
}

# Read available AZs in the selected region and use the first one for public subnet.
data "aws_availability_zones" "available" {
  state = "available"
}

# Fetch latest Ubuntu 22.04 LTS AMI published by Canonical.
# This satisfies the "Ubuntu Free Tier AMI" requirement when used with t2.micro.
data "aws_ami" "ubuntu_free_tier" {
  most_recent = true
  owners      = ["099720109477"] # Canonical official account

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
