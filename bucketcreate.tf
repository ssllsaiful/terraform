provider "aws" {
  region = "us-west-1" 
}

resource "aws_s3_bucket" "jvai-cdn-bucket" {
  bucket = "jvai-cdn-bucket" 
}

# Allow Public Access
resource "aws_s3_bucket_public_access_block" "allow_public" {
  # Fixed: Now matches the name 'jvai-cdn-bucket' above
  bucket = aws_s3_bucket.jvai-cdn-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public Read Policy
resource "aws_s3_bucket_policy" "public_read" {
  # Fixed: Now matches the name 'jvai-cdn-bucket'
  bucket = aws_s3_bucket.jvai-cdn-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGet"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.jvai-cdn-bucket.arn}/*"
      },
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.allow_public]
}

# --- Outputs ---
output "bucket_name" {
  # Fixed: Matches the name 'jvai-cdn-bucket'
  value = aws_s3_bucket.jvai-cdn-bucket.id
}

output "bucket_url" {
  # Fixed: Matches the name 'jvai-cdn-bucket'
  value = "https://${aws_s3_bucket.jvai-cdn-bucket.bucket}.s3.us-west-1.amazonaws.com"
}