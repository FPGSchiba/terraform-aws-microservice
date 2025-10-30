locals {
  parent_resource_id = var.parent_id == null ? data.aws_api_gateway_rest_api.api.root_resource_id : var.parent_id
  sibling_children = [
    for r in data.aws_api_gateway_resources.all.items : r
    if r.parent_id == local.parent_resource_id
  ]
  matching_children = [
    for r in local.sibling_children : r
    if r.path_part == var.path_name
  ]
  existing_child = length(local.matching_children) > 0 ? local.matching_children[0] : null

  # Final resource id to use everywhere
  target_resource_id = local.existing_child != null ? local.existing_child.id : (
    aws_api_gateway_resource.this[0].id
  )

  target_resource_path = local.existing_child != null ? local.existing_child.path : aws_api_gateway_resource.this[0].path
}
