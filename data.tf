data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_api_gateway_rest_api" "api" {
  name = var.api_name
}

# If user supplies a known existing path, resolve it.
# Important: This data source errors if the path doesn't exist. We guard with count.
data "aws_api_gateway_resource" "existing" {
  count       = var.existing_resource_path != null ? 1 : 0
  rest_api_id = data.aws_api_gateway_rest_api.api.id
  path        = var.existing_resource_path
}
