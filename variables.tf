variable "api_name" {
  description = "A REST API Gateway name used to deploy all methods and stages on."
  type        = string
}

variable "prefix" {
  description = "The Prefix used to deploy the lambda function."
  type        = string
}

variable "path_name" {
  description = "The resource Path used on the api. If this value is a Path Variable, please use the name_overwrite variable."
  type        = string
}

variable "parent_id" {
  description = "The id of a parent resource, if a parent resource is necessary."
  type        = string
  default     = null
}

variable "code_dir" {
  description = "The path to the code to run the lambda function."
  type        = string
}

variable "cors_enabled" {
  description = "If the api path is ready for cors requests."
  type        = bool
}

variable "http_methods" {
  description = "The HTTP Methods used for this API Path. ('GET', 'POST', 'PUT', 'DELETE', 'HEAD')"
  type        = list(string)

  validation {
    condition     = alltrue([for method in var.http_methods : contains(["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH", "TRACE"], method)])
    error_message = "Only the following HTTP Methods are supported: ('GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'PATCH', 'TRACE'). Please read the documentation in order to understand this better."
  }
}

variable "layer_arns" {
  description = "The Lambda Layer ARNs."
  type        = list(string)
  default     = []
}

variable "runtime" {
  description = "Lambda Runtime"
  type        = string
  default     = "provided.al2"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = null
}

variable "main_filename" {
  type        = string
  description = "Main filename of the lambda function (only needed for go Lambda functions)"
  default     = "main.go"
}

variable "environment_variables" {
  description = "Environment variables used by the lambda function"
  type        = map(string)
  default     = {}
}

variable "enable_tracing" {
  description = "Enable active tracing"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Number of seconds, until the Lambda timeouts"
  type        = number
  default     = 3
}

variable "additional_iam_statements" {
  description = "Additional permissions added to the lambda function"
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "control_allow_origin" {
  description = "The CORS Access-Control-Allow-Origin header value."
  type        = string
  default     = "*"
}

variable "authorization_type" {
  description = "The type of Authorization used on this microservice. ('NONE' or 'COGNITO_USER_POOLS')"
  type        = string
  default     = "NONE"
}

variable "cognito_scopes" {
  description = "The Authorization scope from cognito_user_pools. (Only Used if: authorization_type == 'COGNITO_USER_POOLS')"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "authorizer_id" {
  description = "The Authorizer ID for cognito_user_pools. (Only Used if: authorization_type == 'COGNITO_USER_POOLS')"
  type        = string
  default     = null
  nullable    = true
}

variable "name_overwrite" {
  description = "If the path_name contains any special Characters this Variable can be used to overwrite the Lambda Name."
  type        = string
  default     = null
}
