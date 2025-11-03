# terraform-aws-microservice
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | github.com/FPGSchiba/terraform-aws-lambda | v2.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_integration.options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.options_200](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_response.this_200](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_response.this_500](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_resource.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_iam_statements"></a> [additional\_iam\_statements](#input\_additional\_iam\_statements) | Additional permissions added to the lambda function | <pre>list(object({<br/>    actions   = list(string)<br/>    resources = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | The API Gateway REST API ID where the microservice will be deployed. | `string` | n/a | yes |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of Authorization used on this microservice. ('NONE' or 'COGNITO\_USER\_POOLS') | `string` | `"NONE"` | no |
| <a name="input_authorizer_id"></a> [authorizer\_id](#input\_authorizer\_id) | The Authorizer ID for cognito\_user\_pools. (Only Used if: authorization\_type == 'COGNITO\_USER\_POOLS') | `string` | `null` | no |
| <a name="input_code_dir"></a> [code\_dir](#input\_code\_dir) | The path to the code to run the lambda function. | `string` | n/a | yes |
| <a name="input_cognito_scopes"></a> [cognito\_scopes](#input\_cognito\_scopes) | The Authorization scope from cognito\_user\_pools. (Only Used if: authorization\_type == 'COGNITO\_USER\_POOLS') | `list(string)` | `null` | no |
| <a name="input_control_allow_origin"></a> [control\_allow\_origin](#input\_control\_allow\_origin) | The CORS Access-Control-Allow-Origin header value. | `string` | `"*"` | no |
| <a name="input_cors_enabled"></a> [cors\_enabled](#input\_cors\_enabled) | If the api path is ready for cors requests. | `bool` | n/a | yes |
| <a name="input_create_resource"></a> [create\_resource](#input\_create\_resource) | Whether to create a new API Gateway resource. Set to false when using existing\_resource\_id. | `bool` | `true` | no |
| <a name="input_enable_tracing"></a> [enable\_tracing](#input\_enable\_tracing) | Enable active tracing | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables used by the lambda function | `map(string)` | `{}` | no |
| <a name="input_existing_resource_id"></a> [existing\_resource\_id](#input\_existing\_resource\_id) | ID of an existing API Gateway resource to attach methods to. Only used when create\_resource is false. | `string` | `null` | no |
| <a name="input_go_additional_ldflags"></a> [go\_additional\_ldflags](#input\_go\_additional\_ldflags) | Additional -X ldflags for go build command as key-value pairs (e.g., {"github.com/fpgschiba/volleygoals/router.SelectedHandler" = "GetTeam"}) | `map(string)` | `{}` | no |
| <a name="input_go_build_tags"></a> [go\_build\_tags](#input\_go\_build\_tags) | Build tags for go build command | `list(string)` | `[]` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler | `string` | `null` | no |
| <a name="input_http_methods"></a> [http\_methods](#input\_http\_methods) | The HTTP Methods used for this API Path. ('GET', 'POST', 'PUT', 'DELETE', 'HEAD') | `list(string)` | n/a | yes |
| <a name="input_layer_arns"></a> [layer\_arns](#input\_layer\_arns) | The Lambda Layer ARNs. | `list(string)` | `[]` | no |
| <a name="input_name_overwrite"></a> [name\_overwrite](#input\_name\_overwrite) | If the path\_name contains any special Characters this Variable can be used to overwrite the Lambda Name. | `string` | `null` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | The id of a parent resource, if a parent resource is necessary. | `string` | `null` | no |
| <a name="input_path_name"></a> [path\_name](#input\_path\_name) | The resource Path used on the api. If this value is a Path Variable, please use the name\_overwrite variable. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The Prefix used to deploy the lambda function. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Runtime | `string` | `"provided.al2"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group rules to apply | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>    rules = list(object({<br/>      type             = string<br/>      from_port        = optional(number)<br/>      to_port          = optional(number)<br/>      ip_protocol      = string<br/>      ipv4_cidr_blocks = list(string)<br/>      ipv6_cidr_blocks = list(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The IDs of the subnets where the lambda function will be deployed | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Number of seconds, until the Lambda timeouts | `number` | `3` | no |
| <a name="input_vpc_dualstack"></a> [vpc\_dualstack](#input\_vpc\_dualstack) | Whether to deploy the lambda function in a dualstack VPC (IPv4 and IPv6). Only used if vpc\_networked is true. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to deploy the lambda function in. If this value is null, the lambda function will be deployed outside of a VPC. | `string` | `null` | no |
| <a name="input_vpc_networked"></a> [vpc\_networked](#input\_vpc\_networked) | If the lambda function should be deployed in a VPC. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_resource_id"></a> [api\_resource\_id](#output\_api\_resource\_id) | The ID of the target API Gateway resource (existing or created). |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda function |
<!-- END_TF_DOCS -->