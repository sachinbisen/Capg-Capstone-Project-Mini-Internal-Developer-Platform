# Remote backend stores Terraform state in S3 so CI/CD runs share one durable state file.
# This prevents duplicate infrastructure creation from ephemeral GitHub Actions runners.
terraform {
  backend "s3" {
    bucket  = "sachin-mini-idp-terraform-state"
    key     = "mini-idp/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
