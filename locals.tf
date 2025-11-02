locals {
  # Use the explicit boolean flag
  should_create_resource = var.create_resource

  # Determine the parent resource ID
  parent_resource_id = var.parent_id == null ? data.aws_api_gateway_rest_api.api.root_resource_id : var.parent_id

  # Determine the target resource ID
  # If not creating, use the provided ID; otherwise use the created resource
  target_resource_id = var.create_resource ? aws_api_gateway_resource.this[0].id : var.existing_resource_id
}
