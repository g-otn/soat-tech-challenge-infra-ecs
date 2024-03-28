# module "lambda_identification_nationalid" {
#   source = "https://github.com/soat-tech-challenge/lambda-identification-nationalid/releases/download/phase-4/artifact-phase-5.zip"
# }

# module "lambda_authorizer_client" {
#   source = "https://github.com/soat-tech-challenge/lambda-authorizer-client/releases/download/phase-4/artifact-phase-5.zip"
# }

# data "archive_file" "lambda1" {
#   type        = "zip"
#   source_file = "${path.module}/init.tpl"
#   output_path = "${path.module}/files/init.zip"
# }

# resource "aws_lambda_function" "identification_nationalid" {
#   filename      = terraform_data.download_archive_lambda1.output
#   function_name = "SOAT_TC_Lambda_Identification_NationalID"
#   description   = "Generates Client JWT using National ID"
#   role          = data.aws_iam_role.lab_role.arn
#   handler       = "index.handler"

#   source_code_hash = filebase64sha256(terraform_data.download_archive_lambda1.output)

#   runtime = "nodejs20.x"

#   environment {
#     variables = {
#       BACKEND_URL     = local.alb_url
#       JWT_PRIVATE_KEY = var.client_jwt_private_key
#     }
#   }

#   vpc_config {
#     subnet_ids         = local.private_subnets_ids
#     security_group_ids = [local.default_sg_id]
#   }

#   logging_config {
#     log_format = "Text"
#     log_group  = aws_cloudwatch_log_group.lambda_identification_nationalid.name
#   }
# }

# resource "aws_lambda_function" "authorizer_client" {
#   filename      = terraform_data.download_archive_lambda2.output
#   function_name = "SOAT_TC_Lambda_Authorizer_Client"
#   description   = "Authorizer Lambda for Client requests"
#   role          = data.aws_iam_role.lab_role.arn
#   handler       = "index.handler"

#   source_code_hash = filebase64sha256(terraform_data.download_archive_lambda2.output)

#   runtime = "nodejs20.x"

#   environment {
#     variables = {
#       BACKEND_URL     = local.alb_url
#       JWT_PRIVATE_KEY = var.client_jwt_private_key
#     }
#   }

#   logging_config {
#     log_format = "Text"
#     log_group  = aws_cloudwatch_log_group.lambda_authorizer_client.name
#   }
# }
