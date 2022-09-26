resource "aws_api_gateway_rest_api" "example-api-gateway" {
  name = "example-api-gateway"
}

resource "aws_api_gateway_resource" "example-api-gateway-resource" {
  rest_api_id = aws_api_gateway_rest_api.example-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.example-api-gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "example-api-gateway-method" {
  rest_api_id      = aws_api_gateway_rest_api.example-api-gateway.id
  resource_id      =  aws_api_gateway_resource.example-api-gateway-resource.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "example-api-gateway-integration" {
  rest_api_id             = aws_api_gateway_rest_api.example-api-gateway.id
  resource_id             = aws_api_gateway_resource.example-api-gateway-resource.id
  http_method             = aws_api_gateway_method.example-api-gateway-method.http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example-lambda.invoke_arn
  credentials = "arn:aws:iam::${data.aws_caller_identity.example.account_id}:role/example-api-gateway-invoke-role"
}

resource "aws_api_gateway_deployment" "example-api-gateway-deployment" {
  rest_api_id = aws_api_gateway_rest_api.example-api-gateway.id
  stage_name  = "dev"
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.example-api-gateway-method.id,
      aws_api_gateway_integration.example-api-gateway-integration.id,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}
