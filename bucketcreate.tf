provider "aws" {
  region = "us-west-1" 
}

# --- Single S3 Bucket ---
resource "aws_s3_bucket" "jvai-cdn_bucket" {

  bucket = "jvai-cdn_bucket" 
}

# Allow Public Access (Required for the policy to work)
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.cdn_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public Read Policy
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.cdn_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGet"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cdn_bucket.arn}/*"
      },
    ]
  })
  # This ensures the 'Public Access Block' is disabled BEFORE the policy is applied
  depends_on = [aws_s3_bucket_public_access_block.allow_public]
}

# --- Outputs ---
output "bucket_name" {
  value = aws_s3_bucket.cdn_bucket.id
}

output "bucket_url" {
  value = "https://${aws_s3_bucket.cdn_bucket.bucket}.s3.us-west-1.amazonaws.com"
}