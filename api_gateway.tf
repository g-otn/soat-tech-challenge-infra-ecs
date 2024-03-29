locals {
  api_id          = data.tfe_outputs.network.values.api_gw_gateway_api.id
  proxy_to_alb_id = data.tfe_outputs.network.values.api_gw_integration_proxy_to_alb.id
}

// ----- Authorizers -----

resource "aws_apigatewayv2_authorizer" "lambda_authorizer_client" {
  api_id           = local.api_id
  authorizer_type  = "REQUEST"
  authorizer_uri   = aws_lambda_function.authorizer_client.invoke_arn
  identity_sources = ["$request.header.Authorization"]
  name             = "SOAT-TC_API_Gateway_Authorizer__Lambda_Authorizer_Client"

  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = true
}

// ----- Integrations -----

resource "aws_apigatewayv2_integration" "lambda_identification_nationalid" {
  api_id           = local.api_id
  integration_type = "AWS_PROXY"

  description        = "Intercept identification request for token generation flow"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.identification_nationalid.invoke_arn

  payload_format_version = "2.0"
}

// ----- Routes -----
// Routes should be declared on terraform-network whenever possible. The routes below
// depend on terraform-computing resources, they are declared here to avoid cyclic dependencies.

resource "aws_apigatewayv2_route" "client_identification" {
  api_id    = local.api_id
  route_key = "POST /identification/clients/identification"

  target = "integrations/${aws_apigatewayv2_integration.lambda_identification_nationalid.id}"
}

resource "aws_apigatewayv2_route" "order_checkout_and_listing" {
  api_id    = local.api_id
  route_key = "ANY /order/orders" // due to Servlet Filter urlPatterns not supporting specific HTTP methods

  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer_client.id
  authorization_type = "CUSTOM"
  target             = "integrations/${local.proxy_to_alb_id}"
}

resource "aws_apigatewayv2_route" "order_confirmation" {
  api_id    = local.api_id
  route_key = "POST /payment/payments/initialize"

  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer_client.id
  authorization_type = "CUSTOM"
  target             = "integrations/${local.proxy_to_alb_id}"

}
