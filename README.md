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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | github.com/FPGSchiba/terraform-aws-lambda | v2.1.1 |

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
| [aws_api_gateway_rest_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/api_gateway_rest_api) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_iam_statements"></a> [additional\_iam\_statements](#input\_additional\_iam\_statements) | Additional permissions added to the lambda function | <pre>list(object({<br/>    actions   = list(string)<br/>    resources = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | A REST API Gateway name used to deploy all methods and stages on. | `string` | n/a | yes |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of Authorization used on this microservice. ('NONE' or 'COGNITO\_USER\_POOLS') | `string` | `"NONE"` | no |
| <a name="input_authorizer_id"></a> [authorizer\_id](#input\_authorizer\_id) | The Authorizer ID for cognito\_user\_pools. (Only Used if: authorization\_type == 'COGNITO\_USER\_POOLS') | `string` | `null` | no |
| <a name="input_code_dir"></a> [code\_dir](#input\_code\_dir) | The path to the code to run the lambda function. | `string` | n/a | yes |
| <a name="input_cognito_scopes"></a> [cognito\_scopes](#input\_cognito\_scopes) | The Authorization scope from cognito\_user\_pools. (Only Used if: authorization\_type == 'COGNITO\_USER\_POOLS') | `list(string)` | `null` | no |
| <a name="input_control_allow_origin"></a> [control\_allow\_origin](#input\_control\_allow\_origin) | The CORS Access-Control-Allow-Origin header value. | `string` | `"*"` | no |
| <a name="input_cors_enabled"></a> [cors\_enabled](#input\_cors\_enabled) | If the api path is ready for cors requests. | `bool` | n/a | yes |
| <a name="input_enable_tracing"></a> [enable\_tracing](#input\_enable\_tracing) | Enable active tracing | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables used by the lambda function | `map(string)` | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler | `string` | `null` | no |
| <a name="input_http_methods"></a> [http\_methods](#input\_http\_methods) | The HTTP Methods used for this API Path. ('GET', 'POST', 'PUT', 'DELETE', 'HEAD') | `list(string)` | n/a | yes |
| <a name="input_layer_arns"></a> [layer\_arns](#input\_layer\_arns) | The Lambda Layer ARNs. | `list(string)` | `[]` | no |
| <a name="input_main_filename"></a> [main\_filename](#input\_main\_filename) | Main filename of the lambda function (only needed for go Lambda functions) | `string` | `"main.go"` | no |
| <a name="input_name_overwrite"></a> [name\_overwrite](#input\_name\_overwrite) | If the path\_name contains any special Characters this Variable can be used to overwrite the Lambda Name. | `string` | `null` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | The id of a parent resource, if a parent resource is necessary. | `string` | `null` | no |
| <a name="input_path_name"></a> [path\_name](#input\_path\_name) | The resource Path used on the api. If this value is a Path Variable, please use the name\_overwrite variable. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The Prefix used to deploy the lambda function. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Runtime | `string` | `"provided.al2"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group rules to apply | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>    ingress_rules = list(object({<br/>      type        = string<br/>      from_port   = optional(number)<br/>      to_port     = optional(number)<br/>      ip_protocol = string<br/>      cidr_block  = string<br/>    }))<br/>    egress_rules = list(object({<br/>      type        = string<br/>      from_port   = optional(number)<br/>      to_port     = optional(number)<br/>      ip_protocol = string<br/>      cidr_block  = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Number of seconds, until the Lambda timeouts | `number` | `3` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to deploy the lambda function in. If this value is null, the lambda function will be deployed outside of a VPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_resource_id"></a> [api\_resource\_id](#output\_api\_resource\_id) | The ID of the API Gateway Resource used to invoke the lambda function. |
<!-- END_TF_DOCS -->