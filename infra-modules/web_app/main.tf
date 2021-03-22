# Frontend Environment
module "static_website_and_cloudfront_distribution" {
  source = "./frontend"
  bucket_name = "${var.application_name}-${var.environment}"
  bucket_acl = "public-read"
  environment = var.environment
}