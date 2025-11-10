variable "api_id" {
  description = "The API Gateway REST API ID where the microservice will be deployed."
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

variable "json_logging" {
  description = "Enable structured JSON logging"
  type        = bool
  default     = false
}

variable "app_log_level" {
  description = "Log level for the application logs"
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"], var.app_log_level)
    error_message = "app_log_level must be one of: TRACE, DEBUG, INFO, WARN, ERROR, FATAL."
  }
}

variable "system_log_level" {
  description = "Log level for the system logs"
  type        = string
  default     = "WARN"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARN"], var.system_log_level)
    error_message = "system_log_level must be one of: DEBUG, INFO, WARN."
  }
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

variable "security_groups" {
  description = "List of security group rules to apply"
  type = list(object({
    name        = string
    description = string
    rules = list(object({
      type             = string
      from_port        = optional(number)
      to_port          = optional(number)
      ip_protocol      = string
      ipv4_cidr_blocks = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
  validation {
    condition = alltrue([
      for sg in var.security_groups : alltrue([
        alltrue([for rule in sg.rules : contains(["egress", "ingress"], rule.type)])
      ])
    ])
    error_message = "Each rule.type must be either 'egress' or 'ingress'."
  }
  default = []
}

variable "vpc_networked" {
  description = "If the lambda function should be deployed in a VPC."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID to deploy the lambda function in. If this value is null, the lambda function will be deployed outside of a VPC."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The IDs of the subnets where the lambda function will be deployed"
  type        = list(string)
  default     = []
}

variable "vpc_dualstack" {
  description = "Whether to deploy the lambda function in a dualstack VPC (IPv4 and IPv6). Only used if vpc_networked is true."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "go_build_tags" {
  description = "Build tags for go build command"
  type        = list(string)
  default     = []
}

variable "go_additional_ldflags" {
  description = "Additional -X ldflags for go build command as key-value pairs (e.g., {\"github.com/fpgschiba/volleygoals/router.SelectedHandler\" = \"GetTeam\"})"
  type        = map(string)
  default     = {}
}


variable "create_resource" {
  description = "Whether to create a new API Gateway resource. Set to false when using existing_resource_id."
  type        = bool
  default     = true
}

variable "existing_resource_id" {
  description = "ID of an existing API Gateway resource to attach methods to. Only used when create_resource is false."
  type        = string
  default     = null
}
