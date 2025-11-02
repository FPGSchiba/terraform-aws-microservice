terraform {
  required_version = ">= 1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5"
    }
  }
}

variable "suffix" {
  type        = string
  description = "A suffix used to deploy the testing resources."
}

variable "code_dir" {
  type        = string
  description = "Code directory used to test the microservice module."
}

variable "cors_enabled" {
  type        = bool
  description = "If CORS is enabled on the microserivce to test."
}

variable "prefix" {
  type        = string
  description = "The prefix for the microservice to test."
}

variable "path_name" {
  type        = string
  description = "The path name used to deploy the microservice behind."
}


resource "aws_api_gateway_rest_api" "api" {
  name = "microservice-terratest-${var.suffix}"
}

module "microservice" {
  source       = "../../"
  api_id       = aws_api_gateway_rest_api.api.id
  parent_id    = aws_api_gateway_rest_api.api.root_resource_id
  code_dir     = var.code_dir
  cors_enabled = var.cors_enabled
  http_methods = ["GET"]
  path_name    = var.path_name
  prefix       = var.prefix

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    module.microservice,
    aws_api_gateway_rest_api.api
  ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "test"
}

output "stage_url" {
  value = aws_api_gateway_stage.this.invoke_url
}
