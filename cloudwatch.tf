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
