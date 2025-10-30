output "api_resource_id" {
  description = "The ID of the target API Gateway resource (existing or created)."
  value       = local.target_resource_id
}

output "api_resource_path" {
  description = "The path of the target API Gateway resource (existing or created)."
  value       = local.target_resource_path
}
