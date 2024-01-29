#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/SOAT-TC_ECS_${var.id}_Service_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC ECS ${var.name} Service Log Group"
  }
}
