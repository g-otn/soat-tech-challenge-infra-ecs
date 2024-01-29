terraform {
  required_version = ">= 0.12.26"

  cloud {
    organization = "soat-tech-challenge"

    workspaces {
      name = "computing-staging"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.51.1"
    }
  }
}

provider "aws" {
  region = var.aws_region

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token

  default_tags {
    tags = {
      Organization = "soat-tech-challenge"
      Workspace    = "computing-staging"
    }
  }
}
