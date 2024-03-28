# AWS Academy Vocareum AWS Learner Lab 
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "tfe_outputs" "network" {
  organization = "soat-tech-challenge"
  workspace    = "network-staging"
}

data "tfe_outputs" "database" {
  organization = "soat-tech-challenge"
  workspace    = "database-staging"
}

