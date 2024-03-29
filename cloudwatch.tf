#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "api_gateway_access_log" {
  name              = "/aws/apigateway/SOAT-TC_API_Gateway_Access_Log"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC API GW Default Stage Access Log Cloudwatch Log Group"
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "lambda_authorizer_client" {
  name              = "/aws/lambda/SOAT-TC_Lambda_Authorizer_Client_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC Lambda Authorizer Client Cloudwatch Log Group"
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "lambda_identification_nationalid" {
  name              = "/aws/lambda/SOAT-TC_Lambda_Identification_NationalID_Logs"
  retention_in_days = 30

  tags = {
    Name : "SOAT-TC Lambda Identification National ID Cloudwatch Log Group"
  }
}
