variable "environment" {
  description = "Defines the environment of the infrastructure"
  type        = string
}
variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
  default     = "raw-bucket-flavio-de-assis"
}