data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_api_gateway_rest_api" "api" {
  name = var.api_name
}
data "aws_api_gateway_resources" "all" {
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}
