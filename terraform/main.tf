provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "static_site" {
  bucket = "2398060-rugved"  # Replace with your desired S3 bucket name
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
# S3 Bucket for Static Website


# Disable Block Public Access Settings


# S3 Website Configuration


# S3 Bucket Policy for Public Access


# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Custom IAM Policy with Full Access
resource "aws_iam_policy" "custom_full_access" {
  name        = "CustomFullAccessPolicy"
  description = "Custom policy granting full access to all AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

# Attach Custom Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_custom_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.custom_full_access.arn
}

# Attach Custom Policy to CodePipeline Role
resource "aws_iam_role_policy_attachment" "codepipeline_custom_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.custom_full_access.arn
}
