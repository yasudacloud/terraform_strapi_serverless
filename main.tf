terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "aws_region" {
  default = "ap-northeast-1"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "example" {}

output "account_id" {
  value = data.aws_caller_identity.example.account_id
}
