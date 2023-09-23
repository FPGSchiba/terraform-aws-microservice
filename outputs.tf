output "api_resource_id" {
  description = "The ID of the API Gateway Resource used to invoke the lambda function."
  value       = aws_api_gateway_resource.this.id
}
