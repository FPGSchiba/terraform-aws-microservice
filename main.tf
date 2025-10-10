module "lambda" {
  source = "github.com/FPGSchiba/terraform-aws-lambda?ref=v2.1.1"

  code_dir                  = var.code_dir
  name                      = "${var.prefix}-${var.name_overwrite == null ? var.path_name : var.name_overwrite}"
  layer_arns                = var.layer_arns
  runtime                   = var.runtime
  handler                   = var.handler
  environment_variables     = var.environment_variables
  enable_tracing            = var.enable_tracing
  timeout                   = var.timeout
  additional_iam_statements = var.additional_iam_statements
  main_filename             = var.main_filename
  security_groups           = var.security_groups
  vpc_id                    = var.vpc_id
  tags                      = var.tags
}

resource "aws_api_gateway_resource" "this" {
  parent_id   = var.parent_id == null ? data.aws_api_gateway_rest_api.api.root_resource_id : var.parent_id
  path_part   = var.path_name
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "options" {
  count = var.cors_enabled ? 1 : 0

  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.this.id
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method_response" "options_200" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = data.aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  status_code = aws_api_gateway_method_response.options_200[0].status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.http_methods)},OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.control_allow_origin}'"
  }
}

resource "aws_api_gateway_method" "this" {
  for_each = toset(var.http_methods)

  authorization        = var.authorization_type
  http_method          = each.value
  resource_id          = aws_api_gateway_resource.this.id
  rest_api_id          = data.aws_api_gateway_rest_api.api.id
  authorizer_id        = var.authorization_type == "COGNITO_USER_POOLS" ? var.authorizer_id == null ? null : var.authorizer_id : null
  authorization_scopes = var.authorization_type == "COGNITO_USER_POOLS" ? var.cognito_scopes == null ? null : var.cognito_scopes : null
}

resource "aws_api_gateway_integration" "this" {
  for_each = toset(var.http_methods)

  rest_api_id             = data.aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.function_invoke_arn
}

resource "aws_api_gateway_method_response" "this_200" {
  for_each = toset(var.http_methods)

  http_method = each.value
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  status_code = 200
  response_parameters = var.cors_enabled ? {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  } : null

  depends_on = [aws_api_gateway_method.this]
}

resource "aws_api_gateway_method_response" "this_500" {
  for_each = toset(var.http_methods)

  http_method = each.value
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  status_code = 500
  response_parameters = var.cors_enabled ? {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  } : null

  depends_on = [aws_api_gateway_method.this]
}

resource "aws_lambda_permission" "this" {
  for_each = toset(var.http_methods)

  statement_id  = "AllowExecutionFromAPIGateway${each.value}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${data.aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.this[each.key].http_method}${aws_api_gateway_resource.this.path}"
}
