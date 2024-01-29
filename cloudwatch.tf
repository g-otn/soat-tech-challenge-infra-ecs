#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ecs_identification_lg" {
  name              = "/aws/apigateway/SOAT-TC_ECS_Identification_Service_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC ECS Identification Service Log Group"
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ecs_order_svc_lg" {
  name              = "/aws/apigateway/SOAT-TC_ECS_Order_Service_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC ECS Order Service Log Group"
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ecs_payment_svc_lg" {
  name              = "/aws/apigateway/SOAT-TC_ECS_Payment_Service_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC ECS Payment Service Log Group"
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ecs_production_svc_lg" {
  name              = "/aws/apigateway/SOAT-TC_ECS_Production_Service_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC ECS Production Service Log Group"
  }
}
