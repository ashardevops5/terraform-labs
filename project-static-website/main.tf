terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "demo-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.demo-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  
}


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./index.html"
  key    = "index.html"

}



resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./style.css"
  key    = "style.css"
}



output "name" {
  value = random_id.rand_id.hex
}