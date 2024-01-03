terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.14.0"
    }
  }
}

provider "aws" {
    region = "ap-south-2"
    assume_role {
      role_arn = "arn:aws:iam:****:role/tf-admin"
    }
    default_tags {
      tags = {
        component = var.component
        created-by = "terraform"
        environment = var.environment
      }
    }
}