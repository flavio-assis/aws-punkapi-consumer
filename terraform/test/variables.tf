//Environment
variable "environment" {
  description = "Defines the environment of the infrastructure"
  type        = string
}

//IAM
variable "firehose_role_name" {
  description = "Name of the role chosen for Firehose"
  type        = string
  default     = "FirehoseRole"
}

variable "lambda_to_kinesis_stream_role_name" {
  description = "Name of the role chosen for Lambda"
  type        = string
  default     = "S3ToKinesisStream"
}

// Kinesis
variable "kinesis_stream_name" {
  description = "Kinesis Stream Name"
  type        = string
  default     = "KinesisStreamPunkApi"
}

variable "kinesis_shard_count" {
  description = "Number of shards in Kinesis Stream"
  type        = number
  default     = 1
}

variable "kinesis_retention_period" {
  description = "Hours that the data records are accessible after they are added to the stream. Values must be between 24 and 168."
  type        = number
  default     = 24
}

variable "kinesis_firehose_name" {
  description = "Kinesis Firehose Delivery Name"
  type        = string
  default     = "PunkApiDeliveryToS3"
}

variable "kinesis_firehose_buffer_interval" {
  description = "Firehose buffer interval"
  type        = number
  default     = 60
}
variable "kinesis_firehose_buffer_size" {
  description = "Firehose buffer size"
  type        = number
  default     = 5
}

// S3
variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
  default     = "raw-bucket-flavio-de-assis"
}

variable "lambda_function_name" {
  description = "Name of the Lambda Function"
  type        = string
  default     = "PunkApiCollector"
}

// Lambda
variable "lambda_function_handler" {
  description = "Handler for Lambda function"
  type        = string
  default     = "main.lambda_handler"
}

variable "lambda_function_filename" {
  description = "Zipped file containing Lambda function"
  type        = string
  default     = "../../aws_lambda/aws_lambda.zip"
}

variable "execution_timeout" {
  description = "Timeout for Lambda Function Execution in seconds"
  type        = number
  default     = 60
}

variable "lambda_get_api_max_requests" {
  description = "Max Punk Api calls in Lambda Function"
  type        = number
  default     = 1
}
