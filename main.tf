module "lambda" {
  source = "github.com/FPGSchiba/terraform-aws-lambda?ref=v2.3.4"

  code_dir                  = var.code_dir
  name                      = "${var.prefix}-${var.name_overwrite == null ? var.path_name : var.name_overwrite}"
  layer_arns                = var.layer_arns
  runtime                   = var.runtime
  handler                   = var.handler
  environment_variables     = var.environment_variables
  enable_tracing            = var.enable_tracing
  timeout                   = var.timeout
  additional_iam_statements = var.additional_iam_statements
  security_groups           = var.security_groups
  vpc_id                    = var.vpc_id
  tags                      = var.tags
  go_build_tags             = var.go_build_tags
  go_additional_ldflags     = var.go_additional_ldflags
  vpc_networked             = var.vpc_networked
  vpc_dualstack             = var.vpc_dualstack
  subnet_ids                = var.subnet_ids
  json_logging              = var.json_logging
  app_log_level             = var.app_log_level
  system_log_level          = var.system_log_level
}

# Create the API resource only when not binding to an existing resource
resource "aws_api_gateway_resource" "this" {
  count = local.should_create_resource ? 1 : 0

  rest_api_id = var.api_id
  parent_id   = var.parent_id
  path_part   = var.path_name
}

# CORS: OPTIONS method
resource "aws_api_gateway_method" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id   = var.api_id
  resource_id   = local.target_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = var.api_id
  resource_id = local.target_resource_id
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

  rest_api_id = var.api_id
  resource_id = local.target_resource_id
  http_method = aws_api_gateway_method.options[0].http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = var.api_id
  resource_id = local.target_resource_id
  http_method = aws_api_gateway_method.options[0].http_method
  status_code = aws_api_gateway_method_response.options_200[0].status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.http_methods)},OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.control_allow_origin}'"
  }
}

# Primary methods
resource "aws_api_gateway_method" "this" {
  for_each = toset(var.http_methods)

  rest_api_id          = var.api_id
  resource_id          = local.target_resource_id
  http_method          = each.value
  authorization        = var.authorization_type
  authorizer_id        = var.authorization_type == "COGNITO_USER_POOLS" ? (var.authorizer_id == null ? null : var.authorizer_id) : null
  authorization_scopes = var.authorization_type == "COGNITO_USER_POOLS" ? (var.cognito_scopes == null ? null : var.cognito_scopes) : null
}

resource "aws_api_gateway_integration" "this" {
  for_each = toset(var.http_methods)

  rest_api_id             = var.api_id
  resource_id             = local.target_resource_id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  timeout_milliseconds    = var.timeout * 1000
  uri                     = module.lambda.function_invoke_arn
}

resource "aws_api_gateway_method_response" "this_200" {
  for_each = toset(var.http_methods)

  rest_api_id = var.api_id
  resource_id = local.target_resource_id
  http_method = each.value
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

  rest_api_id = var.api_id
  resource_id = local.target_resource_id
  http_method = each.value
  status_code = 500
  response_parameters = var.cors_enabled ? {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  } : null

  depends_on = [aws_api_gateway_method.this]
}

# Lambda permissions per method
resource "aws_lambda_permission" "this" {
  for_each = toset(var.http_methods)

  statement_id_prefix = "AllowExecutionFromAPIGateway${each.value}-"
  action              = "lambda:InvokeFunction"
  function_name       = module.lambda.function_name
  principal           = "apigateway.amazonaws.com"
  source_arn          = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${var.api_id}/*/${aws_api_gateway_method.this[each.key].http_method}/*"

  lifecycle {
    ignore_changes = [source_arn]
  }
}
