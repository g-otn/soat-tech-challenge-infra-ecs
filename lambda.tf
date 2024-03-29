module "lambda_identification_nationalid" {
  source = "https://github.com/soat-tech-challenge/lambda-identification-nationalid/releases/download/phase-4/artifact-phase-5.tar.gz"
}

module "lambda_authorizer_client" {
  source = "https://github.com/soat-tech-challenge/lambda-authorizer-client/releases/download/phase-4/artifact-phase-5.tar.gz"
}

data "archive_file" "lambda_identification_nationalid" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/modules/lambda_identification_nationalid"
  output_path = "${path.module}/lambda1.zip"
}

data "archive_file" "lambda_authorizer_client" {
  type        = "zip"
  source_dir  = "${path.module}/.terraform/modules/lambda_authorizer_client"
  output_path = "${path.module}/lambda2.zip"
}

resource "aws_lambda_function" "identification_nationalid" {
  filename      = data.archive_file.lambda_identification_nationalid.output_path
  function_name = "SOAT_TC_Lambda_Identification_NationalID"
  description   = "Generates Client JWT using National ID"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "index.handler"
  timeout       = 10 # debug

  source_code_hash = data.archive_file.lambda_identification_nationalid.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      BACKEND_URL     = "${local.alb_url}/identification"
      JWT_PRIVATE_KEY = var.client_jwt_private_key
    }
  }

  vpc_config {
    subnet_ids         = local.private_subnets_ids
    security_group_ids = [local.default_sg_id]
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_identification_nationalid.name
  }
}

resource "aws_lambda_function" "authorizer_client" {
  filename      = data.archive_file.lambda_authorizer_client.output_path
  function_name = "SOAT_TC_Lambda_Authorizer_Client"
  description   = "Authorizer Lambda for Client requests"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_authorizer_client.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      JWT_PUBLIC_KEY = var.client_jwt_public_key
    }
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_authorizer_client.name
  }
}

resource "aws_lambda_permission" "execute_lambda1_from_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway_SOAT_TC_Lambda_Identification_NationalID"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.identification_nationalid.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${local.api_execution_arn}/*/*"
}

resource "aws_lambda_permission" "execute_lambda2_from_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway_SOAT_TC_Lambda_Authorizer_Client"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer_client.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${local.api_execution_arn}/*/*"
}
