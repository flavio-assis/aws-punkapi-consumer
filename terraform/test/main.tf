provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

module "iam" {
  source                             = "../modules/iam"
  firehose_role_name                 = var.firehose_role_name
  lambda_to_kinesis_stream_role_name = var.lambda_to_kinesis_stream_role_name
  kinesis_stream_arn                 = module.kinesis_stream.kinesis_stream_arn
  bucket_arn                         = module.aws_s3.bucket_arn
  depends_on                         = [module.kinesis_stream, module.aws_s3]
}

module "cloud_watch" {
  source              = "../modules/cloud_watch"
  environment         = var.environment
  lambda_function_arn = module.lambda_function.lambda_function_arn
  depends_on          = [module.lambda_function]
}

module "kinesis_stream" {
  source                   = "../modules/kinesis_stream"
  environment              = var.environment
  kinesis_stream_name      = var.kinesis_stream_name
  kinesis_shard_count      = var.kinesis_shard_count
  kinesis_retention_period = var.kinesis_retention_period
}

module "kinesis_firehose" {
  source                           = "../modules/kinesis_firehose"
  environment                      = var.environment
  kinesis_firehose_name            = var.kinesis_firehose_name
  kinesis_firehose_buffer_interval = var.kinesis_firehose_buffer_interval
  kinesis_firehose_buffer_size     = var.kinesis_firehose_buffer_size
  kinesis_stream_arn               = module.kinesis_stream.kinesis_stream_arn
  role_arn                         = module.iam.firehose_role_arn
  raw_bucket_arn                   = module.aws_s3.bucket_arn
  depends_on                       = [module.iam, module.aws_s3, module.kinesis_stream]
}

module "lambda_function" {
  source                      = "../modules/lambda"
  environment                 = var.environment
  lambda_function_name        = var.lambda_function_name
  lambda_function_handler     = var.lambda_function_handler
  role_arn                    = module.iam.lambda_to_kinesis_stream_arn
  filename                    = var.lambda_function_filename
  kinesis_stream_name         = var.kinesis_stream_name
  depends_on                  = [module.iam]
  execution_timeout           = var.execution_timeout
  lambda_get_api_max_requests = var.lambda_get_api_max_requests
}

module "lambda_trigger" {
  source               = "../modules/lambda_trigger"
  lambda_function_name = module.lambda_function.lambda_function_name
  source_arn           = module.cloud_watch.cloud_watch_event_rule_arn
  depends_on           = [module.cloud_watch, module.lambda_function]
}

module "aws_s3" {
  source      = "../modules/s3"
  environment = var.environment
  bucket_name = "${var.bucket_name}-${var.environment}"
}