terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }

  backend "s3" {
    bucket = "sk-tf-remote-state-prod"
    key    = "expense-dev-rds" # you should have unique keys with in the bucket, same key should not be used in other repos or tf projects
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}