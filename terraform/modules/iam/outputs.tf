output "firehose_role_arn" {
  value       = aws_iam_role.firehose_role.arn
  description = "Firehose Role ARN"
}

output "lambda_to_kinesis_stream_arn" {
  value       = aws_iam_role.lambda_to_kinesis_stream.arn
  description = "Lambda To Kinesis Role ARN"
}