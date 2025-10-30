locals {
  # Parent id is either provided or the root
  parent_resource_id = var.parent_id == null ? data.aws_api_gateway_rest_api.api.root_resource_id : var.parent_id

  # Whether caller provided an existing resource path we should bind to
  using_existing_by_path = var.existing_resource_path != null

  # Safely pull existing id/path if provided (count=1); else nulls
  existing_id   = try(data.aws_api_gateway_resource.existing[0].id, null)
  existing_path = try(data.aws_api_gateway_resource.existing[0].path, null)

  # Decide whether to create a resource in this module
  should_create_resource = !local.using_existing_by_path && var.create_if_missing

  # Final target id/path: prefer existing when provided, otherwise the created one
  target_resource_id   = local.using_existing_by_path ? local.existing_id : try(aws_api_gateway_resource.this[0].id, null)
  target_resource_path = local.using_existing_by_path ? local.existing_path : try(aws_api_gateway_resource.this[0].path, null)
}
