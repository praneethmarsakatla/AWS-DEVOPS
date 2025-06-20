output "s3_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}
