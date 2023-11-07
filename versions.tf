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
      version = "4.67.0"
    }
  }
}
