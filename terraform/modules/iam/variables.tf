variable "firehose_role_name" {
  description = "Name of the role chosen for Firehose"
  type        = string
  default     = "FirehoseRole"
}

variable "lambda_to_kinesis_stream_role_name" {
  description = "Name of the role chosen for Lambda"
  type        = string
  default     = "LambdaToKinesisStream"
}


variable "kinesis_stream_arn" {
  description = "Input Kinesis Stream ARN"
  type        = string
  default     = ""
}

variable "bucket_arn" {
  description = "Destination S3 bucket ARN"
  type        = string
  default     = ""
}