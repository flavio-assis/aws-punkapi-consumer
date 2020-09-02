variable "environment" {
  description = "Defines the environment of the infrastructure"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda Function"
  type        = string
  default     = "PunkApiCollector"
}

variable "lambda_function_handler" {
  description = "Handler for Lambda function"
  type        = string
  default     = "main.lambda_handler"
}

variable "role_arn" {
  description = "S3 to Kinesis Stream Role ARN"
  type        = string
  default     = ""
}

variable "filename" {
  description = "Zipped file containing Lambda function"
  type        = string
  default     = "../../aws_lambda/aws_lambda.zip"
}

variable "kinesis_stream_name" {
  description = "Pass Kinesis Stream Name in order to configure the Lambda function ingestion process"
  type        = string
  default     = ""
}

variable "execution_timeout" {
  description = "Timeout for Lambda Function Execution in seconds"
  type        = number
  default     = 60
}