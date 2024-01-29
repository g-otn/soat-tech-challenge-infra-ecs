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
data "template_file" "identification_svc_container_definition" {
  template = file("./container_definitions/identification.json")
  vars = {
    id                    = "identification"
    aws_access_key        = var.aws_access_key
    aws_secret_key        = var.aws_secret_key
    aws_session_token     = var.aws_session_token
    aws_dynamodb_endpoint = "dynamodb.${var.aws_region}.amazonaws.com"
    client_jwt_pub_key    = var.client_jwt_public_key
    aws_region            = var.aws_region
  }
}


data "template_file" "order_svc_container_definition" {
  template = file("./container_definitions/order.json")
  vars = {
    id                     = "order"
    db_username            = var.order_svc_db_username
    db_password            = var.order_svc_db_password
    db_name                = var.order_svc_db_name
    db_host                = data.tfe_outputs.database.values.order_svc_db.endpoint
    client_jwt_pub_key     = var.client_jwt_public_key
    api_url_identification = "${data.tfe_outputs.network.values.lb_lb.dns_name}/identification"
    aws_region             = var.aws_region
  }
}

data "template_file" "payment_svc_container_definition" {
  template = file("./container_definitions/payment.json")
  vars = {
    id                 = "payment"
    db_username        = var.payment_svc_db_username
    db_password        = var.payment_svc_db_password
    db_name            = var.payment_svc_db_name
    db_host            = data.tfe_outputs.database.values.payment_svc_db.endpoint
    client_jwt_pub_key = var.client_jwt_public_key
    api_url_order      = "${data.tfe_outputs.network.values.lb_lb.dns_name}/order"
    api_url_production = "${data.tfe_outputs.network.values.lb_lb.dns_name}/production"
    aws_region         = var.aws_region
  }
}

data "template_file" "production_svc_container_definition" {
  template = file("./container_definitions/production.json")
  vars = {
    id                    = "production"
    aws_access_key        = var.aws_access_key
    aws_secret_key        = var.aws_secret_key
    aws_session_token     = var.aws_session_token
    aws_dynamodb_endpoint = "dynamodb.${var.aws_region}.amazonaws.com"
    client_jwt_pub_key    = var.client_jwt_public_key
    aws_region            = var.aws_region
  }
}
