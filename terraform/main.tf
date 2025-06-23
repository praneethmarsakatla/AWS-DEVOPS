provider "aws" {
  region = "us-east-2" 
}

resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "bucket-praneeth-static" 

  website {
    index_document = "index.html"
  }

  tags = {
    Project     = "StaticWebsiteDeployment"
    Environment = "Production"
  }
}

# Enable Public Access 
resource "aws_s3_bucket_public_access_block" "static_website_bucket_public_access_block" {
  bucket = aws_s3_bucket.static_website_bucket.id

  # Set these to false to allow public policies for static website hosting
  block_public_acls       = false 
  block_public_policy     = false
  ignore_public_acls      = false 
  restrict_public_buckets = false
}



resource "aws_s3_bucket_policy" "static_website_bucket_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  # policy allows GetObject for public read
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": [
          "${aws_s3_bucket.static_website_bucket.arn}/*"
        ]
      }
    ]
  })


  depends_on = [aws_s3_bucket_public_access_block.static_website_bucket_public_access_block]
}

output "website_endpoint" {
  value = aws_s3_bucket.static_website_bucket.website_endpoint
}
