output "api_resource_id" {
  description = "The ID of the target API Gateway resource (existing or created)."
  value       = local.target_resource_id
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.function_arn
}
