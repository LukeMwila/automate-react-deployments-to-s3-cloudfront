generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  provider "aws" {
     region  = "eu-west-1"
     profile = "serverless-deployer"
  }

  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
}
  required_version = "~> 0.13.6"
  backend "s3" {}
  }
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt                 = true
    bucket                  = "devopsjs-terraform-state"
    key                     = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table          = "devopsjs-terraform-lock-table"
    profile                 = "serverless-deployer"
    region                  = "eu-west-1"
  }
}
