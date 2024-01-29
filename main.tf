module "identification" {
  source = "./modules/service"
  id     = "identification"
  name   = "Identification"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = data.template_file.identification_svc_container_definition.rendered
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = data.tfe_outputs.network.values.vpc_public_subnets[*].id
  security_groups_ids = [data.tfe_outputs.network.values.vpc_vpc.default_security_group_id]

  lb_container_port   = 8001
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_identification_svc_tg.arn
}
module "order" {
  source = "./modules/service"
  id     = "order"
  name   = "Order"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = data.template_file.order_svc_container_definition.rendered
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = data.tfe_outputs.network.values.vpc_public_subnets[*].id
  security_groups_ids = [data.tfe_outputs.network.values.vpc_vpc.default_security_group_id]

  lb_container_port   = 8002
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_order_svc_tg.arn
}

module "payment" {
  source = "./modules/service"
  id     = "payment"
  name   = "Payment"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = data.template_file.payment_svc_container_definition.rendered
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = data.tfe_outputs.network.values.vpc_public_subnets[*].id
  security_groups_ids = [data.tfe_outputs.network.values.vpc_vpc.default_security_group_id]

  lb_container_port   = 8003
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_payment_svc_tg.arn
}

module "production" {
  source = "./modules/service"
  id     = "production"
  name   = "Production"

  task_role_arn         = data.aws_iam_role.lab_role.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  container_definitions = data.template_file.production_svc_container_definition.rendered
  ecs_cluster_id        = aws_ecs_cluster.main.id

  subnet_ids          = data.tfe_outputs.network.values.vpc_public_subnets[*].id
  security_groups_ids = [data.tfe_outputs.network.values.vpc_vpc.default_security_group_id]

  lb_container_port   = 8004
  lb_target_group_arn = data.tfe_outputs.network.values.lb_tgs.ecs_production_svc_tg.arn
}
