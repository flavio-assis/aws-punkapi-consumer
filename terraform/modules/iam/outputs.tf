output "firehose_role_arn" {
  value       = aws_iam_role.firehose_role.arn
  description = "Firehose Role ARN"
}

output "s3_to_kinesis_stream_arn" {
  value       = aws_iam_role.s3_to_kinesis_stream.arn
  description = "S3 To Kinesis Role ARN"
}