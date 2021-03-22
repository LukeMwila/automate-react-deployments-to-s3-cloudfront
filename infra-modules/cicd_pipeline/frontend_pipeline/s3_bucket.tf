# S3 bucket used by CodePipeline for artifacts
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "${var.pipeline_bucket_name}-${var.environment}"
  acl    = var.bucket_acl

  tags = {
    Name = "${var.pipeline_bucket_name}-${var.environment}"
  }
}

# S3 bucket used by CodeBuild for cache
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "${var.codebuild_bucket_name}-${var.environment}"
  acl    = var.bucket_acl

  tags = {
    Name = "${var.codebuild_bucket_name}-${var.environment}"
  }
}