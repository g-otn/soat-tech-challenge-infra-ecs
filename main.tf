locals {
  alb_url           = "http://${data.tfe_outputs.network.values.lb_lb.dns_name}"
  dynamodb_endpoint = "dynamodb.${var.aws_region}.amazonaws.com"
  sqs_endpoint      = data.tfe_outputs.network.values.vpc_endpoint_sqs.dns_entry[0].dns_name

  public_subnets_ids  = data.tfe_outputs.network.values.vpc_public_subnets[*].id
  private_subnets_ids = data.tfe_outputs.network.values.vpc_private_subnets[*].id
  default_sg_id       = data.tfe_outputs.network.values.vpc_vpc.default_security_group_id
}

locals {
  identification_svc_container_definition = templatefile("./container_definitions/identification.json", {
    id         = "identification"
    aws_region = var.aws_region

    aws_access_key    = var.aws_access_key
    aws_secret_key    = var.aws_secret_key
    aws_session_token = var.aws_session_token

    aws_dynamodb_endpoint = local.dynamodb_endpoint
  })
  order_svc_container_definition = templatefile("./container_definitions/order.json", {
    id         = "order"
    aws_region = var.aws_region

    db_username = var.order_svc_db_username
    db_password = var.order_svc_db_password
    db_name     = var.order_svc_db_name
    db_host     = data.tfe_outputs.database.values.order_svc_db.endpoint

    client_jwt_pub_key     = var.client_jwt_public_key
    api_url_identification = "${local.alb_url}/identification"
  })
  payment_svc_container_definition = templatefile("./container_definitions/payment.json", {
    id         = "payment"
    aws_region = var.aws_region

    db_username = var.payment_svc_db_username
    db_password = var.payment_svc_db_password
    db_name     = var.payment_svc_db_name
    db_host     = data.tfe_outputs.database.values.payment_svc_db.endpoint

    client_jwt_pub_key = var.client_jwt_public_key
    api_url_order      = "${local.alb_url}/order"
    api_url_production = "${local.alb_url}/production"

    aws_access_key    = var.aws_access_key
    aws_secret_key    = var.aws_secret_key
    aws_session_token = var.aws_session_token

    aws_sqs_endpoint = local.sqs_endpoint
  })
  production_svc_container_definition = templatefile("./container_definitions/production.json", {
    id         = "production"
    aws_region = var.aws_region

    client_jwt_pub_key = var.client_jwt_public_key

    aws_access_key    = var.aws_access_key
    aws_secret_key    = var.aws_secret_key
    aws_session_token = var.aws_session_token

    aws_dynamodb_endpoint = local.dynamodb_endpoint
    aws_sqs_endpoint      = local.sqs_endpoint
  })
}

module "identification_service" {
  source = "./modules/service"
  id     = "identification"
  name   = "Identification"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = local.identification_svc_container_definition
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = local.public_subnets_ids
  security_groups_ids = [local.default_sg_id]

  lb_container_port   = 8001
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_identification_svc_tg.arn
}

module "order_service" {
  source = "./modules/service"
  id     = "order"
  name   = "Order"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = local.order_svc_container_definition
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = local.public_subnets_ids
  security_groups_ids = [local.default_sg_id]

  lb_container_port   = 8002
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_order_svc_tg.arn
}

module "payment_service" {
  source = "./modules/service"
  id     = "payment"
  name   = "Payment"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = local.payment_svc_container_definition
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = local.public_subnets_ids
  security_groups_ids = [local.default_sg_id]

  lb_container_port   = 8003
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_payment_svc_tg.arn
}

module "production_service" {
  source = "./modules/service"
  id     = "production"
  name   = "Production"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = local.production_svc_container_definition
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = local.public_subnets_ids
  security_groups_ids = [local.default_sg_id]

  lb_container_port   = 8004
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_production_svc_tg.arn
}
