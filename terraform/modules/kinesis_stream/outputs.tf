output "kinesis_stream_arn" {
  value       = aws_kinesis_stream.kinesis_stream.arn
  description = "Kinesis Stream ARN"
}