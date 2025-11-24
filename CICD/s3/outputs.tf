#################################################################################
####################################### S3 Outputs ################################
#################################################################################

output "artifact_bucket_name" {
  value       = aws_s3_bucket.artifact.bucket
  description = "S3 Bucket Name"
}

output "artifact_bucket_arn" {
  value       = aws_s3_bucket.artifact.arn
  description = "S3 Bucket ARN"
}
