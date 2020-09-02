variable "environment" {
  description = "Defines the environment of the infrastructure"
  type        = string
}

variable "lambda_function_arn" {
  description = "Lambda function ARN to trigger"
  type        = string
  default     = ""
}
