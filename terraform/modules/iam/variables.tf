variable "firehose_role_name" {
  description = "Name of the role chosen for Firehose"
  type        = string
  default     = "FirehoseRole"
}

variable "s3_to_kinesis_stream_role_name" {
  description = "Name of the role chosen for S3"
  type        = string
  default     = "S3ToKinesisStream"
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