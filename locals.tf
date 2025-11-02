locals {
  # Determine if we should create a new API Gateway resource
  # If existing_resource_id is provided, we'll use that existing resource
  # If existing_resource_path is provided (legacy), we'll look it up
  # Otherwise, create a new resource
  should_create_resource = var.existing_resource_id == null

  # Determine the parent resource ID
  parent_resource_id = var.parent_id == null ? data.aws_api_gateway_rest_api.api.root_resource_id : var.parent_id

  # Determine the target resource ID (the resource where methods will be attached)
  # Priority: existing_resource_id > newly created resource > legacy path lookup
  target_resource_id = (
    var.existing_resource_id != null ? var.existing_resource_id :
    local.should_create_resource ? aws_api_gateway_resource.this[0].id :
    var.existing_resource_id
  )
}
