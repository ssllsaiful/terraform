provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "my-unique-bucket-001-xyz"
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "my-unique-bucket-002-xyz"
}

resource "aws_s3_bucket" "bucket3" {
  bucket = "my-unique-bucket-003-xyz"
}